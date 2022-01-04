import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Starts the application initialization upon starting the app.
///
/// Navigates to the [HomeScreen] When a previous session has been restored.
/// Navigates to the [LoginScreen] otherwise.
class ApplicationCubit extends Cubit<ApplicationState> with HarpyLogger {
  ApplicationCubit({
    required this.systemBrightness,
    required this.themeBloc,
    required this.configCubit,
    required this.authenticationCubit,
  }) : super(ApplicationState.uninitialized) {
    _initialize();
  }

  final Brightness systemBrightness;
  final ThemeBloc themeBloc;
  final ConfigCubit configCubit;
  final AuthenticationCubit authenticationCubit;

  Future<void> _initialize() async {
    if (!kReleaseMode) {
      initializeLogger();
    }

    // sets the visibility detector controller update interval to fire more
    // frequently
    // this is used by the VisibilityDetector for the ListCardAnimation
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 50,
    );

    // need the device info before we continue with updating the system ui
    await app<HarpyInfo>().initialize();

    await Future.wait([
      FlutterDisplayMode.setHighRefreshRate().handleError(silentErrorHandler),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
    ]);

    // initialize config after harpy preferences initialized
    configCubit.initialize();

    await authenticationCubit.restoreSession();

    if (authenticationCubit.state.isAuthenticated) {
      // navigate to home screen after session has been restored
      app<HarpyNavigator>().pushReplacementNamed(HomeScreen.route);
    } else {
      // navigate to login screen
      app<HarpyNavigator>().pushReplacementNamed(
        LoginScreen.route,
        type: RouteType.fade,
      );
    }

    emit(ApplicationState.initialized);
  }
}

enum ApplicationState {
  uninitialized,
  initialized,
}
