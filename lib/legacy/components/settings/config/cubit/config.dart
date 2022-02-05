part of 'config_cubit.dart';

/// Configuration for ui components of the app.
class Config extends Equatable {
  const Config({
    required this.fontSizeDelta,
    required this.compactMode,
    required this.bottomAppBar,
    required this.displayFont,
    required this.bodyFont,
    required this.hideHomeTabBar,
    required this.showAbsoluteTime,
  });

  final double fontSizeDelta;
  final bool compactMode;
  final bool bottomAppBar;
  final String displayFont;
  final String bodyFont;

  /// Whether to automatically hide the home tab bar when swiping up / down.
  final bool hideHomeTabBar;

  final bool showAbsoluteTime;

  static const defaultConfig = Config(
    fontSizeDelta: 0,
    compactMode: false,
    bottomAppBar: false,
    displayFont: kDisplayFontFamily,
    bodyFont: kBodyFontFamily,
    hideHomeTabBar: true,
    showAbsoluteTime: false,
  );

  @override
  List<Object?> get props => [
        fontSizeDelta,
        compactMode,
        bottomAppBar,
        displayFont,
        bodyFont,
        hideHomeTabBar,
        showAbsoluteTime
      ];

  Config copyWith({
    double? fontSizeDelta,
    bool? compactMode,
    bool? bottomAppBar,
    String? displayFont,
    String? bodyFont,
    bool? hideHomeTabBar,
    bool? showAbsoluteTime,
  }) {
    return Config(
      fontSizeDelta: fontSizeDelta ?? this.fontSizeDelta,
      compactMode: compactMode ?? this.compactMode,
      bottomAppBar: bottomAppBar ?? this.bottomAppBar,
      displayFont: displayFont ?? this.displayFont,
      bodyFont: bodyFont ?? this.bodyFont,
      hideHomeTabBar: hideHomeTabBar ?? this.hideHomeTabBar,
      showAbsoluteTime: showAbsoluteTime ?? this.showAbsoluteTime,
    );
  }
}

extension ConfigStateExtension on Config {
  double get paddingValue => compactMode ? 12 : 16;
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
