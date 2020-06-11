import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:harpy/components/application/bloc/application/application_event.dart';
import 'package:harpy/components/application/bloc/application/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:meta/meta.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({
    @required this.authenticationBloc,
  }) {
    add(InitializeEvent());
  }

  final AuthenticationBloc authenticationBloc;

  @override
  ApplicationState get initialState => const AwaitingInitializationState();

  @override
  Stream<ApplicationState> mapEventToState(
    ApplicationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
