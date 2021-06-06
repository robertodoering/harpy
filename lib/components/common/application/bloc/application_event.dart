part of 'application_bloc.dart';

@immutable
abstract class ApplicationEvent {
  const ApplicationEvent();

  Stream<ApplicationState> applyAsync({
    ApplicationState? currentState,
    ApplicationBloc? bloc,
  });
}

/// The event used to initialize the app.
///
/// Runs when the application bloc is created as soon as the application starts.
class InitializeEvent extends ApplicationEvent {
  InitializeEvent();

  final HarpyNavigator? harpyNavigator = app<HarpyNavigator>();
  final ChangelogPreferences? changelogPreferences =
      app<ChangelogPreferences>();
  final HarpyInfo? harpyInfo = app<HarpyInfo>();

  static final Logger _log = Logger('InitializeEvent');

  /// Used for common initialization that always needs to be run and is
  /// independent of a previously authenticated user.
  Future<void> _commonInitialization(ApplicationBloc bloc) async {
    _log.fine('start common initialization');

    initLogger();

    // sets the visibility detector controller update interval to fire more
    // frequently
    // this is used by the VisibilityDetector for the ListCardAnimation
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 50,
    );

    // need the device info before we continue with updating the system ui
    await app<HarpyInfo>().initialize();

    // update the system ui to match the initial theme
    bloc.themeBloc.updateSystemUi(bloc.themeBloc.harpyTheme);

    await Future.wait<void>(<Future<void>>[
      FlutterDisplayMode.setHighRefreshRate(),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
    ]);
  }

  /// Waits for the [AuthenticationBloc] to complete the twitter session
  /// initialization and handles user specific initialization.
  ///
  /// Returns whether the uses is authenticated.
  Future<bool> _userInitialization(
    ApplicationBloc? bloc,
    AuthenticationBloc authenticationBloc,
  ) async {
    _log.fine('start user initialization');

    // start twitter session initialization
    authenticationBloc.add(const InitializeTwitterSessionEvent());

    // wait for the session to initialize
    final authenticated = await authenticationBloc.sessionInitialization.future;

    return authenticated;
  }

  @override
  Stream<ApplicationState> applyAsync({
    ApplicationState? currentState,
    ApplicationBloc? bloc,
  }) async* {
    await _commonInitialization(bloc!);

    final authenticated =
        await _userInitialization(bloc, bloc.authenticationBloc);

    _log.fine('finished app initialization');

    yield InitializedState();

    if (authenticated) {
      // navigate to home screen
      harpyNavigator!.pushReplacementNamed(HomeScreen.route);
    } else {
      // navigate to login screen
      harpyNavigator!.pushReplacementNamed(
        LoginScreen.route,
        type: RouteType.fade,
      );
    }
  }
}
