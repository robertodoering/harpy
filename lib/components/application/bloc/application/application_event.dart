import 'dart:async';

import 'package:harpy/components/application/bloc/application/application_bloc.dart';
import 'package:harpy/components/application/bloc/application/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_event.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_state.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
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
  /// independed of a previously authenticated user.
  Future<void> _commonInitialization(ApplicationBloc bloc) async {
    _log.fine('start common initialization');

    initLogger();
    bloc.appConfig = await parseAppConfig();
  }

  /// Waits for the [AuthenticationBloc] to complete the twitter session
  /// initialization and handles user specific initialization.
  Future<void> _userInitialization(
    ApplicationBloc bloc,
    AuthenticationBloc authenticationBloc,
  ) async {
    _log.fine('start user initialization');

    // start twitter session initialization
    authenticationBloc.add(InitializeTwitterSessionEvent(bloc.appConfig));

    // wait for the session to initialize
    final bool authenticated =
        await authenticationBloc.sessionInitialization.future;

    if (authenticated) {}
  }

  @override
  Stream<ApplicationState> applyAsync({
    ApplicationState currentState,
    ApplicationBloc bloc,
  }) async* {
    await _commonInitialization(bloc);
    await _userInitialization(bloc, bloc.authenticationBloc);

    _log.fine('finished app initialization');

    yield const InitializedState();

    if (bloc.authenticationBloc.state is AuthenticatedState) {
      // navigate to home screen
      app<HarpyNavigator>().pushReplacementNamed(HomeScreen.route);
    } else {
      // navigate to login screen
      app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route);
    }
  }
}
