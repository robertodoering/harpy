import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';

/// A list of [HarpyTheme]s that can be used as the theme for the app.
final List<HarpyTheme> predefinedThemes = <HarpyTheme>[
  HarpyTheme.fromData(crow),
  HarpyTheme.fromData(swan),
  HarpyTheme.fromData(phoenix),
  HarpyTheme.fromData(harpy),
];

final HarpyThemeData crow = HarpyThemeData()
  ..name = 'crow'
  ..backgroundColors = <int>[0xff000005, 0xff17233d]
  ..accentColor = 0xff4178f0;

final HarpyThemeData swan = HarpyThemeData()
  ..name = 'swan'
  ..backgroundColors = <int>[0xffffffff]
  ..accentColor = 0xff444444;

final HarpyThemeData phoenix = HarpyThemeData()
  ..name = 'phoenix'
  ..backgroundColors = <int>[0xfffc2c2e, 0xffff6215, 0xffff6215, 0xfffc2c2e]
  ..accentColor = 0xffffe60f;

final HarpyThemeData harpy = HarpyThemeData()
  ..name = 'harpy'
  ..backgroundColors = <int>[0xff40148b, 0xff850a2f]
  ..accentColor = 0xffEB3965;
