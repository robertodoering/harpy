import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/connectivity_service.dart';
import 'package:harpy/core/download_service.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:visibility_detector/visibility_detector.dart';

@immutable
abstract class ApplicationEvent {
  const ApplicationEvent();

  Stream<ApplicationState> applyAsync({
    ApplicationState currentState,
    ApplicationBloc bloc,
  });
}

/// The event used to initialize the app.
///
/// Runs when the application bloc is created as soon as the application starts.
class InitializeEvent extends ApplicationEvent {
  InitializeEvent();

  final HarpyNavigator harpyNavigator = app<HarpyNavigator>();
  final ChangelogPreferences changelogPreferences = app<ChangelogPreferences>();
  final HarpyInfo harpyInfo = app<HarpyInfo>();

  static final Logger _log = Logger('InitializeEvent');

  /// Used for common initialization that always needs to be run and is
  /// independent of a previously authenticated user.
  Future<void> _commonInitialization(ApplicationBloc bloc) async {
    _log.fine('start common initialization');

    initLogger();

    // sets the visibility detector controller update interval to zero to fire
    // every frame
    // this is used by the VisibilityDetector for the ListCardAnimation
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // update the system ui to match the initial theme
    bloc.themeBloc.updateSystemUi(bloc.themeBloc.harpyTheme);

    // need to parse app config before we continue with initialization that is
    // reliant on the app config
    await app<AppConfig>().parseAppConfig();

    await Future.wait<void>(<Future<void>>[
      app<HarpyInfo>().initialize(),
      app<ErrorReporter>().initialize(),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
      app<DownloadService>().initialize(),
    ]);
  }

  /// Waits for the [AuthenticationBloc] to complete the twitter session
  /// initialization and handles user specific initialization.
  ///
  /// Returns whether the uses is authenticated.
  Future<bool> _userInitialization(
    ApplicationBloc bloc,
    AuthenticationBloc authenticationBloc,
  ) async {
    _log.fine('start user initialization');

    // start twitter session initialization
    authenticationBloc.add(const InitializeTwitterSessionEvent());

    // wait for the session to initialize
    final bool authenticated =
        await authenticationBloc.sessionInitialization.future;

    return authenticated;
  }

  @override
  Stream<ApplicationState> applyAsync({
    ApplicationState currentState,
    ApplicationBloc bloc,
  }) async* {
    await _commonInitialization(bloc);

    final bool authenticated =
        await _userInitialization(bloc, bloc.authenticationBloc);

    _log.fine('finished app initialization');

    yield InitializedState();

    if (authenticated) {
      // navigate to home screen
      harpyNavigator.pushReplacementHomeScreen(autoLogin: true);
    } else {
      // prevent showing changelog dialog for this version
      changelogPreferences.setToCurrentShownVersion();

      // navigate to login screen
      harpyNavigator.pushReplacementNamed(
        LoginScreen.route,
        type: RouteType.fade,
      );
    }
  }
}
