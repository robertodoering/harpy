import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'authentication_provider.freezed.dart';

final authenticationStateProvider = StateProvider(
  (ref) => const AuthenticationState.unauthenticated(),
  name: 'AuthenticationStateProvider',
);

/// Handles common authentication.
///
/// Authentication logic is split between
/// * [authenticationProvider]
/// * [loginProvider]
/// * [logoutProvider]
final authenticationProvider = Provider(
  (ref) => Authentication(read: ref.read),
  name: 'AuthenticationProvider',
);

class Authentication with LoggerMixin {
  const Authentication({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  /// Restores a previous session if one exists.
  Future<void> restoreSession() async {
    final authPreferences = _read(authPreferencesProvider);

    if (authPreferences.isValid) {
      log.fine('session restored');
      await onLogin(authPreferences);
    } else {
      log.fine('no previous session exists');
    }
  }

  /// Requests the authenticated user's data to finalize the login.
  Future<void> onLogin(AuthPreferences auth) async {
    log.fine('on login');

    final user = await _initializeUser(auth.userId);

    if (user != null) {
      log.info('authenticated user successfully initialized');

      _read(authenticationStateProvider.notifier).state =
          AuthenticationState.authenticated(user: user);
    } else {
      log.info('authenticated user not initialized');

      // failed initializing login
      // remove retrieved session assuming it's not valid anymore
      await onLogout();
    }
  }

  /// Invalidates and removes the saved session.
  Future<void> onLogout() async {
    log.fine('on logout');

    // invalidate token
    _read(twitterApiProvider)
        .client
        .post(Uri.https('api.twitter.com', '1.1/oauth/invalidate_token'))
        .handleError(logErrorHandler)
        .ignore();

    // clear saved session
    _read(authPreferencesProvider.notifier).clearAuth();

    _read(authenticationStateProvider.notifier).state =
        const AuthenticationState.unauthenticated();
  }

  /// Requests the [UserData] for the authenticated user.
  Future<UserData?> _initializeUser(String userId) async {
    final twitterApi = _read(twitterApiProvider);

    dynamic error;

    final user = await twitterApi.userService
        .usersShow(userId: userId)
        .then(UserData.fromUser)
        .handleError((e, st) {
      error = e;
      logErrorHandler(e, st);
    });

    if (error is TimeoutException || error is SocketException) {
      // unable to authenticate user, allow to retry in case of temporary
      // network error
      final retry = await _read(dialogServiceProvider)
          .show<bool>(child: const RetryAuthenticationDialog());

      if (retry != null && retry) {
        return _initializeUser(userId);
      }
    }

    return user;
  }
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
