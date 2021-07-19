part of 'config_cubit.dart';

/// Configuration for ui components of the app.
class Config extends Equatable {
  const Config({
    required this.fontSizeDelta,
    required this.compactMode,
  });

  final double fontSizeDelta;
  final bool compactMode;

  static const defaultConfig = Config(
    fontSizeDelta: 0,
    compactMode: false,
  );

  @override
  List<Object?> get props => [
        fontSizeDelta,
        compactMode,
      ];

  Config copyWith({
    double? fontSizeDelta,
    bool? compactMode,
  }) {
    return Config(
      fontSizeDelta: fontSizeDelta ?? this.fontSizeDelta,
      compactMode: compactMode ?? this.compactMode,
    );
  }
}

extension ConfigStateExtension on Config {
  double get paddingValue => compactMode ? 10 : 16;
  double get smallPaddingValue => paddingValue / 2;

  EdgeInsets get edgeInsets => EdgeInsets.all(paddingValue);

  EdgeInsets edgeInsetsOnly({
    bool left = false,
    bool right = false,
    bool top = false,
    bool bottom = false,
  }) {
    return EdgeInsets.only(
      left: left ? paddingValue : 0,
      right: right ? paddingValue : 0,
      top: top ? paddingValue : 0,
      bottom: bottom ? paddingValue : 0,
    );
  }

  EdgeInsets edgeInsetsSymmetric({
    bool horizontal = false,
    bool vertical = false,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ? paddingValue : 0,
      vertical: vertical ? paddingValue : 0,
    );
  }

  String get fontSizeDeltaName {
    final deltaId = app<HarpyPreferences>().getInt('fontSizeDeltaId', 0);

    return _fontSizeDeltaIdNameMap[deltaId] ?? 'normal';
  }
}

/// Maps the id of the font size to the font size delta value.
const _fontSizeDeltaIdMap = <int, double>{
  -2: -4,
  -1: -2,
  0: 0,
  1: 2,
  2: 4,
};

/// Maps the id of the font size to its display name.
const _fontSizeDeltaIdNameMap = <int, String>{
  -2: 'smallest',
  -1: 'small',
  0: 'normal',
  1: 'big',
  2: 'biggest',
};
