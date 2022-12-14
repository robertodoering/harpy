part of 'harpy_theme.dart';

const kBodyFont = 'OpenSans';
const kDisplayFont = 'Comfortaa';

const kAssetFonts = [
  kBodyFont,
  kDisplayFont,
];

const _fontFamilyFallback = ['NotoSans'];

class HarpyTextTheme {
  HarpyTextTheme({
    required Brightness brightness,
    required double fontSizeDelta,
    required String displayFont,
    required String bodyFont,
  })  : _brightness = brightness,
        _fontSizeDelta = fontSizeDelta,
        _displayFont = displayFont,
        _bodyFont = bodyFont {
    _setupTextTheme();
  }

  final Brightness _brightness;
  final double _fontSizeDelta;
  final String _displayFont;
  final String _bodyFont;

  late final TextTheme textTheme;

  void _setupTextTheme() {
    final typography = _brightness == Brightness.light
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    textTheme = typography.merge(
      TextTheme(
        // display
        displayLarge: _applyDisplayFont(
          const TextStyle(
            fontSize: 64,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        displayMedium: _applyDisplayFont(
          const TextStyle(
            fontSize: 48,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        displaySmall: _applyDisplayFont(
          const TextStyle(
            fontSize: 48,
            letterSpacing: 0,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),

        // headline
        headlineLarge: _applyDisplayFont(
          const TextStyle(
            fontSize: 22,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        headlineMedium: _applyDisplayFont(
          const TextStyle(
            fontSize: 18,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        headlineSmall: _applyDisplayFont(
          const TextStyle(
            fontSize: 20,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),

        // title
        titleLarge: _applyDisplayFont(
          const TextStyle(
            fontSize: 20,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        titleMedium: _applyDisplayFont(
          const TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        titleSmall: _applyDisplayFont(
          const TextStyle(
            height: 1.1,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),

        // body
        bodyLarge: _applyBodyFont(
          const TextStyle(
            fontSize: 14,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        bodyMedium: _applyBodyFont(
          const TextStyle(
            fontSize: 16,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        bodySmall: _applyBodyFont(
          const TextStyle(
            fontSize: 12,
            letterSpacing: .4,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),

        // label
        labelLarge: _applyDisplayFont(
          const TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        labelMedium: _applyDisplayFont(
          const TextStyle(
            fontSize: 14,
            letterSpacing: 1.2,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
        labelSmall: _applyDisplayFont(
          const TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        ),
      ).apply(
        fontSizeDelta: _fontSizeDelta,
      ),
    );
  }

  TextStyle _applyDisplayFont(TextStyle textStyle) {
    return applyFontFamily(
      textStyle: textStyle,
      fontFamily: _displayFont,
      fallback: kDisplayFont,
    );
  }

  TextStyle _applyBodyFont(TextStyle textStyle) {
    return applyFontFamily(
      textStyle: textStyle,
      fontFamily: _bodyFont,
      fallback: kBodyFont,
    );
  }
}

TextStyle applyFontFamily({
  required TextStyle textStyle,
  required String fontFamily,
  String? fallback,
}) {
  if (kAssetFonts.contains(fontFamily)) {
    return textStyle.copyWith(fontFamily: fontFamily);
  }

  try {
    return GoogleFonts.getFont(fontFamily, textStyle: textStyle);
  } catch (e) {
    return fallback != null
        ? textStyle.copyWith(fontFamily: fallback)
        : textStyle;
  }
}
