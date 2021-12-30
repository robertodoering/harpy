import 'dart:async';
import 'dart:io';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/misc.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_cubit.freezed.dart';

/// Handles authentication with twitter using [TwitterAuth] and loads the
/// authenticated user's [UserData].
class AuthenticationCubit extends Cubit<AuthenticationState> with HarpyLogger {
  AuthenticationCubit({
    required this.themeBloc,
  }) : super(const AuthenticationState.unauthenticated());

  final ThemeBloc themeBloc;

  /// Restores a previous session if one exists.
  Future<void> restoreSession() async {
    final token = app<AuthPreferences>().userToken;
    final secret = app<AuthPreferences>().userSecret;
    final userId = app<AuthPreferences>().userId;

    if (token.isNotEmpty && secret.isNotEmpty && userId.isNotEmpty) {
      log.fine('session restored');

      final authSession = TwitterAuthSession(
        token: token,
        tokenSecret: secret,
        userId: userId,
      );

      await _onLogin(authSession);
    } else {
      log.fine('no previous session exists');
    }
  }

  /// Initializes a web bases twitter authentication and navigates to the
  /// [SetupScreen] or [HomeScreen] on successful authentication.
  Future<void> login() async {
    log.fine('logging in');

    if (!app<EnvConfig>().validateAppConfig()) {
      return;
    }

    emit(const AuthenticationState.awaitingAuthentication());

    final result = await app<AuthPreferences>()
        .initializeTwitterAuth()
        .authenticateWithTwitter(
          webviewNavigation: _webviewNavigation,
          onExternalNavigation: launchUrl,
        );

    switch (result.status) {
      case TwitterAuthStatus.success:
        log.fine('login success');

        app<AuthPreferences>().userToken = result.session!.token;
        app<AuthPreferences>().userSecret = result.session!.tokenSecret;
        app<AuthPreferences>().userId = result.session!.userId;

        await _onLogin(result.session!);

        if (state is _Authenticated) {
          if (app<SetupPreferences>().performedSetup) {
            app<HarpyNavigator>().pushReplacementNamed(
              HomeScreen.route,
              type: RouteType.fade,
            );
          } else {
            app<HarpyNavigator>().pushReplacementNamed(
              SetupScreen.route,
              type: RouteType.fade,
            );
          }
        } else {
          app<HarpyNavigator>().pushReplacementNamed(
            LoginScreen.route,
            type: RouteType.fade,
          );
        }

        break;
      case TwitterAuthStatus.failure:
        log.warning(
          'login failed\n\n'
          'If this issue is persistent, see\n'
          'https://github.com/robertodoering/harpy/wiki/Troubleshooting',
        );

        app<MessageService>().show('authentication failed, please try again');

        emit(const AuthenticationState.unauthenticated());

        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );

        break;
      case TwitterAuthStatus.userCancelled:
        log.fine('login cancelled by user');

        emit(const AuthenticationState.unauthenticated());

        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );

        break;
    }
  }

  /// Navigates to the [LoginScreen] and invalidates the active session.
  Future<void> logout({
    @visibleForTesting Duration delay = const Duration(milliseconds: 300),
  }) async {
    log.fine('logging out');

    // reset the theme to the default theme
    themeBloc.add(
      const ThemeEvent.changeTheme(
        lightThemeId: isFree ? 0 : 1,
        darkThemeId: 0,
      ),
    );

    app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);

    // invalidate session after navigation to avoid building the home screen
    // without the user data
    await Future<void>.delayed(delay);
    await _onLogout();
  }

  /// Initializes the twitter api client and requests the authenticated user's
  /// data.
  ///
  /// Emits the [AuthenticationState.authenticated] state if the user has been
  /// requested successfully.
  /// Otherwise [_onLogout] is called to invalidate the user session.
  Future<void> _onLogin(TwitterAuthSession authSession) async {
    log.fine('on login');

    final key = app<EnvConfig>().key(app<AuthPreferences>().auth);
    final secret = app<EnvConfig>().secret(app<AuthPreferences>().auth);

    if (app<TwitterApi>().client is TwitterClient) {
      (app<TwitterApi>().client as TwitterClient)
        ..consumerKey = key
        ..consumerSecret = secret
        ..token = authSession.token
        ..secret = authSession.tokenSecret;
    }

    final user = await _initializeUser(authSession.userId);

    if (user != null) {
      log.fine('authenticated');

      emit(AuthenticationState.authenticated(user: user));

      // initialize the user prefix for the harpy preferences
      app<HarpyPreferences>().prefix = authSession.userId;

      // initialize the custom themes for this user
      themeBloc
        ..add(const ThemeEvent.loadCustomThemes())
        ..add(
          ThemeEvent.changeTheme(
            lightThemeId: app<ThemePreferences>().lightThemeId,
            darkThemeId: app<ThemePreferences>().darkThemeId,
          ),
        );
    } else {
      log.fine('not authenticated');

      // failed initializing login
      // remove retrieved session assuming it's not valid anymore
      await _onLogout();
    }
  }

  /// Invalidates the user token and emits the
  /// [AuthenticationState.unauthenticated] state.
  Future<void> _onLogout() async {
    log.fine('on logout');

    if (app<TwitterApi>().client is TwitterClient) {
      final client = app<TwitterApi>().client as TwitterClient;

      if (client.token.isNotEmpty && client.secret.isNotEmpty) {
        unawaited(
          client
              .post(Uri.https('api.twitter.com', '1.1/oauth/invalidate_token'))
              .handleError(silentErrorHandler),
        );
      }
    }

    app<AuthPreferences>().clearAuth();

    emit(const AuthenticationState.unauthenticated());
  }
}

Future<UserData?> _initializeUser(String userId) async {
  dynamic error;

  final user = await app<TwitterApi>()
      .userService
      .usersShow(userId: userId)
      .then(UserData.fromUser)
      .handleError((dynamic e, st) {
    error = e;
    silentErrorHandler(e, st);
  });

  if (error is TimeoutException || error is SocketException) {
    // unable to authenticate user, allow to retry in case of temporary
    // network error
    final retry = await showDialog<bool>(
      context: app<HarpyNavigator>().state.context,
      builder: (_) => const RetryAuthenticationDialog(),
    );

    if (retry != null && retry) {
      return _initializeUser(userId);
    }
  }

  return user;
}

Future<Uri?> _webviewNavigation(TwitterLoginWebview webview) async {
  return app<HarpyNavigator>().push<Uri>(
    HarpyPageRoute<Uri>(
      builder: (_) => HarpyScaffold(
        title: 'login',
        buildSafeArea: true,
        body: webview,
      ),
      settings: const RouteSettings(name: 'login'),
    ),
  );
}

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.authenticated({
    required UserData user,
  }) = _Authenticated;

  const factory AuthenticationState.unauthenticated() = _Unauthenticated;
  const factory AuthenticationState.awaitingAuthentication() =
      _AwaitingAuthentication;
}

extension AuthenticationStateExtension on AuthenticationState {
  UserData? get user => mapOrNull(authenticated: (value) => value.user);

  bool get isAuthenticated => this is _Authenticated;
  bool get isAwaitingAuthentication => this is _AwaitingAuthentication;
}
