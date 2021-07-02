import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/core.dart';

part 'config_event.dart';
part 'config_state.dart';

/// Handles the configuration of the application which requires the ui to
/// rebuild.
///
/// The configuration is persisted in the preferences.
class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigState.defaultConfig) {
    add(const InitializeConfig());
  }

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    yield* event.applyAsync(state: state, bloc: this);
  }
}
