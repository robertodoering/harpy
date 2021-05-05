import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'application_event.dart';
part 'application_state.dart';

/// The [ApplicationBloc] handles initialization of the app upon start.
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({
    required this.authenticationBloc,
    required this.themeBloc,
  }) : super(AwaitingInitializationState()) {
    add(InitializeEvent());
  }

  final AuthenticationBloc authenticationBloc;

  final ThemeBloc themeBloc;

  static ApplicationBloc of(BuildContext context) =>
      context.watch<ApplicationBloc>();

  @override
  Stream<ApplicationState> mapEventToState(
    ApplicationEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
