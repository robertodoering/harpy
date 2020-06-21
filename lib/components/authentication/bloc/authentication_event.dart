import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  /// Executed when a user is authenticated either after a session is retrieved
  /// automatically after initialization or after a user authenticated manually.
  void onLogin(AuthenticationBloc bloc, AppConfig appConfig) {
    // set twitter api client keys
    (app<TwitterApi>().client as TwitterClient)
      ..consumerKey = appConfig.twitterConsumerKey
      ..consumerSecret = appConfig.twitterConsumerSecret
      ..token = bloc.twitterSession?.token ?? ''
      ..secret = bloc.twitterSession?.secret ?? '';
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
  const InitializeTwitterSessionEvent(this.appConfig);

  final AppConfig appConfig;

  static final Logger _log = Logger('InitializeTwitterSessionEvent');

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    if (appConfig != null) {
      // init twitter login
      bloc.twitterLogin = TwitterLogin(
        consumerKey: appConfig.twitterConsumerKey,
        consumerSecret: appConfig.twitterConsumerSecret,
      );

      // init active twitter session
      bloc.twitterSession = await bloc.twitterLogin.currentSession;

      _log.fine('twitter session initialized');
    }

    bloc.sessionInitialization.complete(bloc.twitterSession != null);

    if (bloc.twitterSession != null) {
      _log.info('authenticated');

      onLogin(bloc, appConfig);

      yield const AuthenticatedState();
    } else {
      _log.info('not authenticated');
      yield const UnauthenticatedState();
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

    await bloc.twitterLogin.logOut();
    bloc.twitterSession = null;

    yield const UnauthenticatedState();

    app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
  }
}

/// Used to authenticate a user.
class LoginEvent extends AuthenticationEvent {
  const LoginEvent(this.appConfig);

  final AppConfig appConfig;

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
        onLogin(bloc, appConfig);
        yield const AuthenticatedState();
        app<HarpyNavigator>().pushReplacementNamed(HomeScreen.route);
        break;
      case TwitterLoginStatus.cancelledByUser:
        _log.info('login cancelled by user');
        app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
        break;
      case TwitterLoginStatus.error:
      default:
        _log.warning('error during login');
        // todo: show message: 'authentication failed, please try again'
        app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
        break;
    }
  }
}
