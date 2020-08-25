import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/application/bloc/application_event.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/settings/theme/bloc/theme_bloc.dart';
import 'package:meta/meta.dart';

/// The [ApplicationBloc] contains handles initialization of the app upon start.
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({
    @required this.authenticationBloc,
    @required this.themeBloc,
  }) : super(AwaitingInitializationState()) {
    add(const InitializeEvent());
  }

  final AuthenticationBloc authenticationBloc;

  final ThemeBloc themeBloc;

  static ApplicationBloc of(BuildContext context) =>
      BlocProvider.of<ApplicationBloc>(context);

  @override
  Stream<ApplicationState> mapEventToState(
    ApplicationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
