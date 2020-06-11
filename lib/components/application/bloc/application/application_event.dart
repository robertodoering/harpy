import 'dart:async';

import 'package:harpy/components/application/bloc/application/application_bloc.dart';
import 'package:harpy/components/application/bloc/application/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_event.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_state.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/logger.dart';
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
class InitializeEvent extends ApplicationEvent {
  const InitializeEvent();

  /// Used for common initialization that always needs to be run and is
  /// independed of a previously authenticated user.
  Future<void> _commonInitialization() async {
    initLogger();
  }

  /// Waits for the [AuthenticationBloc] to complete the twitter session
  /// initialization and handles user specific initialization.
  Future<void> _userInitialization(
    AuthenticationBloc authenticationBloc,
  ) async {
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
    // start twitter session initialization
    bloc.authenticationBloc.add(const InitializeTwitterSessionEvent());

    await _commonInitialization();
    await _userInitialization(bloc.authenticationBloc);

    yield const InitializedState();

    if (bloc.authenticationBloc.state is AuthenticatedState) {
      // navigate to home screen
      HarpyNavigator.pushReplacementNamed(HomeScreen.route);
    } else {
      // navigate to login screen
      HarpyNavigator.pushReplacementNamed(LoginScreen.route);
    }
  }
}
