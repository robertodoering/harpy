import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/common/authentication/cubit/authentication_cubit.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/settings/config/cubit/config_cubit.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Starts the application initialization upon starting the app.
///
/// Navigates to the [HomeScreen] When a previous session has been restored.
/// Navigates to the [LoginScreen] otherwise.
class ApplicationCubit extends Cubit<ApplicationState> with HarpyLogger {
  ApplicationCubit({
    required this.themeBloc,
    required this.configCubit,
    required this.authenticationCubit,
  }) : super(ApplicationState.uninitialized) {
    _initialize();
  }

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

    // update the system ui to match the initial theme
    // (the initial light and dark theme are the same)
    unawaited(_initializeSystemUi(themeBloc.state.darkHarpyTheme));

    await Future.wait([
      FlutterDisplayMode.setHighRefreshRate().handleError(silentErrorHandler),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
    ]);

    // initialize config after harpy preferences initialized
    configCubit.initialize();

    await authenticationCubit.restoreSession();

    if (authenticationCubit.state is Authenticated) {
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

/// Changes the system ui to the initial theme for the initialization.
Future<void> _initializeSystemUi(HarpyTheme initialTheme) async {
  final version = app<HarpyInfo>().deviceInfo?.version.sdkInt ?? -1;

  if (version >= 0 && version <= 29) {
    // a workaround for a bug for android version 10 and below that requires the
    // ui overlay to change the icon brightness to allow for transparency in the
    // navigation bar
    // see: https://github.com/robertodoering/harpy/issues/397
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  updateSystemUi(initialTheme);
}
