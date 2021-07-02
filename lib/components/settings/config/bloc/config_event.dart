part of 'config_bloc.dart';

abstract class ConfigEvent {
  const ConfigEvent();

  Stream<ConfigState> applyAsync({
    required ConfigState state,
    required ConfigBloc bloc,
  });
}

class InitializeConfig extends ConfigEvent {
  const InitializeConfig();

  @override
  Stream<ConfigState> applyAsync({
    required ConfigState state,
    required ConfigBloc bloc,
  }) async* {
    final fontSizeDeltaId = app<HarpyPreferences>().getInt(
      'fontSizeDeltaId',
      0,
    );

    yield state.copyWith(
      compactMode: app<HarpyPreferences>().getBool('compactMode', false),
      fontSizeDelta: _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0,
    );
  }
}

class ResetToDefaultConfig extends ConfigEvent {
  const ResetToDefaultConfig();

  @override
  Stream<ConfigState> applyAsync({
    required ConfigState state,
    required ConfigBloc bloc,
  }) async* {
    app<HarpyPreferences>().setInt('fontSizeDeltaId', 0);
    app<HarpyPreferences>().setBool('compactMode', false);

    yield ConfigState.defaultConfig;
  }
}

class UpdateCompactMode extends ConfigEvent {
  const UpdateCompactMode({
    required this.compactMode,
  });

  final bool compactMode;

  @override
  Stream<ConfigState> applyAsync({
    required ConfigState state,
    required ConfigBloc bloc,
  }) async* {
    app<HarpyPreferences>().setBool('compactMode', compactMode);

    yield state.copyWith(compactMode: compactMode);
  }
}

class UpdateFontSizeDelta extends ConfigEvent {
  const UpdateFontSizeDelta({
    required this.fontSizeDelta,
  });

  final double fontSizeDelta;

  @override
  Stream<ConfigState> applyAsync({
    required ConfigState state,
    required ConfigBloc bloc,
  }) async* {
    final fontSizeDeltaId = _fontSizeDeltaIdMap.entries
        .firstWhere(
          (element) => element.value == fontSizeDelta,
          orElse: () => const MapEntry<int, double>(0, 0),
        )
        .key;

    app<HarpyPreferences>().setInt('fontSizeDeltaId', fontSizeDeltaId);

    yield state.copyWith(
      fontSizeDelta: _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0,
    );
  }
}
