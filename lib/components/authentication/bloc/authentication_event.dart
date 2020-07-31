import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/user_data.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  /// Executed when a user is authenticated either after a session is retrieved
  /// automatically after initialization or after a user authenticated manually.
  ///
  /// Returns `true` when the initialization was successful.
  Future<bool> onLogin(AuthenticationBloc bloc, AppConfigData appConfig) async {
    // set twitter api client keys
    (bloc.twitterApi.client as TwitterClient)
      ..consumerKey = appConfig.twitterConsumerKey
      ..consumerSecret = appConfig.twitterConsumerSecret
      ..token = bloc.twitterSession?.token ?? ''
      ..secret = bloc.twitterSession?.secret ?? '';

    return initializeAuthenticatedUser(bloc);
  }

  /// Retrieves the [UserData] of the authenticated user.
  ///
  /// Returns whether the user was able to be retrieved.
  Future<bool> initializeAuthenticatedUser(AuthenticationBloc bloc) async {
    final String userId = bloc.twitterSession.userId;

    bloc.authenticatedUser = await bloc.twitterApi.userService
        .usersShow(userId: userId)
        .then((User user) => UserData.fromUser(user))
        .catchError(silentErrorHandler);

    return bloc.authenticatedUser != null;
  }

  /// Logs out of the twitter login and resets the [AuthenticationBloc] session
  /// data.
  Future<void> onLogout(AuthenticationBloc bloc) async {
    await bloc.twitterLogin?.logOut();
    bloc.twitterSession = null;
    bloc.authenticatedUser = null;
  }

  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  });
}

/// Used to initialize the twitter session upon app start.
///
/// If the user has been authenticated before, an active twitter session will be
/// retrieved and the users automatically authenticates to skip the login
/// screen. In this case [AuthenticatedState] is yielded.
///
/// If no active twitter session is retrieved, [UnauthenticatedState] is
/// yielded.
class InitializeTwitterSessionEvent extends AuthenticationEvent {
  const InitializeTwitterSessionEvent();

  static final Logger _log = Logger('InitializeTwitterSessionEvent');

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    final AppConfigData appConfigData = app<AppConfig>().data;

    if (appConfigData != null) {
      // init twitter login
      bloc.twitterLogin = TwitterLogin(
        consumerKey: appConfigData.twitterConsumerKey,
        consumerSecret: appConfigData.twitterConsumerSecret,
      );

      // init active twitter session
      bloc.twitterSession = await bloc.twitterLogin.currentSession;

      _log.fine('twitter session initialized');
    }

    if (bloc.twitterSession != null) {
      if (await onLogin(bloc, appConfigData)) {
        // retrieved session and initialized login
        _log.info('authenticated');

        bloc.sessionInitialization.complete(true);
        yield AuthenticatedState();
        return;
      } else {
        // failed initializing login
        await onLogout(bloc);
      }
    }

    _log.info('not authenticated');

    bloc.sessionInitialization.complete(false);
    yield UnauthenticatedState();
  }
}

/// Used to authenticate a user.
class LoginEvent extends AuthenticationEvent {
  const LoginEvent();

  static final Logger _log = Logger('LoginEvent');

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    _log.fine('logging in');

    final TwitterLoginResult result = await bloc.twitterLogin?.authorize();

    switch (result?.status) {
      case TwitterLoginStatus.loggedIn:
        _log.fine('successfully logged in');
        bloc.twitterSession = result.session;

        if (await onLogin(bloc, app<AppConfig>().data)) {
          // successfully initialized the login
          yield AuthenticatedState();
          app<HarpyNavigator>().pushReplacementNamed(
            HomeScreen.route,
            type: RouteType.fade,
          );
        } else {
          // failed initializing login
          await onLogout(bloc);
          app<HarpyNavigator>().pushReplacementNamed(
            LoginScreen.route,
            type: RouteType.fade,
          );
        }

        break;
      case TwitterLoginStatus.cancelledByUser:
        _log.info('login cancelled by user');
        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );
        break;
      case TwitterLoginStatus.error:
      default:
        _log.warning('error during login');
        app<MessageService>().showWarning(
          'Authentication failed, please try again.',
        );
        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );
        break;
    }
  }
}

/// Used to unauthenticate the currently authenticated user.
class LogoutEvent extends AuthenticationEvent {
  const LogoutEvent();

  static final Logger _log = Logger('LogoutEvent');

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    _log.fine('logging out');

    await onLogout(bloc);

    yield UnauthenticatedState();

    app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
  }
}
