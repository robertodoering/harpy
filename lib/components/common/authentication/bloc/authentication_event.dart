part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  static final Logger _log = Logger('AuthenticationEvent');

  /// Executed when a user is authenticated either after a session is retrieved
  /// automatically after initialization or after a user authenticated manually.
  ///
  /// Returns `true` when the initialization was successful.
  Future<bool> onLogin(AuthenticationBloc bloc) async {
    // set twitter api client keys
    (bloc.twitterApi.client as TwitterClient)
      ..consumerKey = twitterConsumerKey
      ..consumerSecret = twitterConsumerSecret
      ..token = bloc.twitterAuthSession.token ?? ''
      ..secret = bloc.twitterAuthSession.tokenSecret ?? '';

    final bool initialized = await initializeAuthenticatedUser(bloc);

    if (initialized) {
      app<AnalyticsService>().logLogin();
    }

    return initialized;
  }

  /// Retrieves the [UserData] of the authenticated user and initializes user
  /// specific preferences.
  ///
  /// Returns `true` if the user was able to be initialized.
  Future<bool> initializeAuthenticatedUser(AuthenticationBloc bloc) async {
    final String userId = bloc.twitterAuthSession.userId;

    bloc.authenticatedUser = await bloc.twitterApi.userService
        .usersShow(userId: userId)
        .then((User user) => UserData.fromUser(user))
        .catchError(silentErrorHandler);

    if (bloc.authenticatedUser != null) {
      // initialize the user prefix for the harpy preferences
      app<HarpyPreferences>().prefix = userId;

      final int selectedThemeId = app<ThemePreferences>().selectedTheme;

      // initialize the custom themes for this user
      bloc.themeBloc.loadCustomThemes();

      if (selectedThemeId != -1) {
        _log.fine('initializing selected theme with id $selectedThemeId');

        bloc.themeBloc.add(ChangeThemeEvent(id: selectedThemeId));
      } else {
        _log.fine('no theme selected for the user');
      }
    }

    return bloc.authenticatedUser != null;
  }

  /// Logs out of the twitter login and resets the [AuthenticationBloc] session
  /// data.
  Future<void> onLogout(AuthenticationBloc bloc) async {
    // wait until navigation changed to clear user information to avoid
    // rebuilding the home screen without an authenticated user and therefore
    // causing unexpected errors
    Future<void>.delayed(const Duration(milliseconds: 400)).then((_) {
      bloc.twitterAuthSession = null;
      bloc.authPreferences.userToken = null;
      bloc.authPreferences.userSecret = null;
      bloc.authPreferences.userId = null;

      bloc.authenticatedUser = null;
    });

    // reset the theme to the default theme
    bloc.themeBloc.add(const ChangeThemeEvent(id: 0));
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
    if (hasTwitterConfig) {
      bloc.twitterAuth = TwitterAuth(
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret,
      );

      // init active twitter session
      final String token = bloc.authPreferences.userToken;
      final String secret = bloc.authPreferences.userSecret;
      final String userId = bloc.authPreferences.userId;

      if (token != null && secret != null && userId != null) {
        bloc.twitterAuthSession = TwitterAuthSession(
          token: token,
          tokenSecret: secret,
          userId: userId,
        );
      }

      _log.fine('twitter session initialized');
    } else {
      _log.warning('no twitter config exists');
    }

    if (bloc.twitterAuthSession != null) {
      if (await onLogin(bloc)) {
        // retrieved session and initialized login
        _log.info('authenticated');

        bloc.sessionInitialization.complete(true);
        yield AuthenticatedState();
        return;
      } else {
        // failed initializing login
        // remove retrieved session assuming it's not valid anymore
        // todo: in case of network error should allow user to retry
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

  Future<TwitterAuthResult> _authenticate(AuthenticationBloc bloc) async {
    return bloc.twitterAuth.authenticateWithTwitter(
      (Widget webview) => app<HarpyNavigator>().state.push(
            FadeRoute<Uri>(
              builder: (_) => HarpyScaffold(title: 'login', body: webview),
              settings: const RouteSettings(name: 'login'),
            ),
          ),
    );
  }

  @override
  Stream<AuthenticationState> applyAsync({
    AuthenticationState currentState,
    AuthenticationBloc bloc,
  }) async* {
    _log.fine('logging in');

    yield AwaitingAuthenticationState();

    final TwitterAuthResult result = await _authenticate(bloc);

    switch (result.status) {
      case TwitterAuthStatus.success:
        _log.fine('successfully logged in');
        bloc.twitterAuthSession = result.session;
        bloc.authPreferences.userToken = result.session.token;
        bloc.authPreferences.userSecret = result.session.tokenSecret;
        bloc.authPreferences.userId = result.session.userId;

        if (await onLogin(bloc)) {
          // successfully initialized the login
          yield AuthenticatedState();

          if (app<SetupPreferences>().performedSetup) {
            // the user has previously performed a setup
            app<HarpyNavigator>().pushReplacementNamed(
              HomeScreen.route,
              type: RouteType.fade,
            );
          } else {
            // new user, should navigate to setup screen
            app<HarpyNavigator>().pushReplacementNamed(
              SetupScreen.route,
              type: RouteType.fade,
            );
          }
        } else {
          // failed initializing login
          await onLogout(bloc);

          yield UnauthenticatedState();
          app<HarpyNavigator>().pushReplacementNamed(
            LoginScreen.route,
            type: RouteType.fade,
          );
        }

        break;
      case TwitterAuthStatus.failure:
        _log.warning('error during login');

        yield UnauthenticatedState();
        app<MessageService>().show('authentication failed, please try again');
        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );
        break;
      case TwitterAuthStatus.userCancelled:
        _log.info('login cancelled by user');

        yield UnauthenticatedState();
        app<HarpyNavigator>().pushReplacementNamed(
          LoginScreen.route,
          type: RouteType.fade,
        );
        break;
    }
  }
}

/// Used to un-authenticate the currently authenticated user.
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

    app<AnalyticsService>().logLogout();

    yield UnauthenticatedState();

    app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
  }
}
