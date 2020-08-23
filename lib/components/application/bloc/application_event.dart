import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/authentication/widgets/login_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/connectivity_service.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

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
/// Run when the application bloc is created.
class InitializeEvent extends ApplicationEvent {
  const InitializeEvent();

  static final Logger _log = Logger('InitializeEvent');

  /// Used for common initialization that always needs to be run and is
  /// independent of a previously authenticated user.
  Future<void> _commonInitialization(ApplicationBloc bloc) async {
    _log.fine('start common initialization');

    initLogger();

    // update the system ui to match the initial theme
    bloc.updateSystemUi();

    // need to parse app config before we continue with initialization that is
    // reliant on the app config
    await app<AppConfig>().parseAppConfig();

    await Future.wait<void>(<Future<void>>[
      app<HarpyInfo>().initialize(),
      app<ErrorReporter>().initialize(),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
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
      app<HarpyNavigator>().pushReplacementNamed(
        HomeScreen.route,
        type: RouteType.fade,
      );
    } else {
      // navigate to login screen
      app<HarpyNavigator>().pushReplacementNamed(
        LoginScreen.route,
        type: RouteType.fade,
      );
    }
  }
}

/// The event to change the app wide theme.
class ChangeThemeEvent extends ApplicationEvent {
  const ChangeThemeEvent({
    @required this.id,
    this.saveSelection = false,
  });

  /// The `id` used to save the selection to.
  ///
  /// 0..9: index of predefined theme (unused indices are reserved)
  /// 10+: index of custom theme (pro only)
  final int id;

  /// Whether the selection should be saved using the [ThemePreferences].
  final bool saveSelection;

  static final Logger _log = Logger('ChangeThemeEvent');

  HarpyTheme _findTheme(ApplicationBloc bloc) {
    try {
      if (id < 10) {
        return predefinedThemes[id];
      } else {
        // selected theme id = 10 -> index = 0
        final int index = id - 10;
        return bloc.customThemeBloc.customThemes[index];
      }
    } catch (e, st) {
      _log.severe('theme id does not correspond to a theme', e, st);
      return null;
    }
  }

  @override
  Stream<ApplicationState> applyAsync({
    ApplicationState currentState,
    ApplicationBloc bloc,
  }) async* {
    final HarpyTheme harpyTheme = _findTheme(bloc);

    if (harpyTheme != null) {
      _log.fine('changing theme to ${harpyTheme.name}');
      bloc.harpyTheme = harpyTheme;

      if (saveSelection) {
        app<ThemePreferences>().selectedTheme = id;
        app<AnalyticsService>().logThemeId(id);
      }
    }

    bloc.updateSystemUi();

    yield InitializedState();
  }
}
