import 'dart:async';

import 'package:harpy/components/application/bloc/application/application_bloc.dart';
import 'package:harpy/components/application/bloc/application/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_event.dart';
import 'package:harpy/misc/logger.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ApplicationEvent {
  Stream<ApplicationState> applyAsync({
    ApplicationState currentState,
    ApplicationBloc bloc,
  });
}

class InitializeEvent extends ApplicationEvent {
  /// Used for common initialization.
  ///
  /// Run upon app start.
  Future<void> _commonInitialization() async {
    initLogger();
  }

  /// Waits for the [AuthenticationBloc] to complete the twitter session
  /// initialization and handles user specific initialization after the session
  /// initialized.
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
    bloc.authenticationBloc.add(InitializeTwitterSessionEvent());

    await _commonInitialization();
    await _userInitialization(bloc.authenticationBloc);

    yield const InitializedState();
    // todo: navigate to login or home screen
  }
}
