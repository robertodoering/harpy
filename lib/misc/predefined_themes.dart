import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A list of [HarpyTheme]s that can be used as the theme for the app.
List<HarpyTheme> get predefinedThemes => <HarpyTheme>[
      HarpyTheme.fromData(crow),
      HarpyTheme.fromData(swan),
      HarpyTheme.fromData(phoenix),
      HarpyTheme.fromData(harpy),
    ];

const HarpyThemeData crow = HarpyThemeData(
  name: 'crow',
  backgroundColors: <int>[0xff000005, 0xff17233d],
  accentColor: 0xff2196f3,
);

const HarpyThemeData swan = HarpyThemeData(
  name: 'swan',
  backgroundColors: <int>[0xffffffff],
  accentColor: 0xff444444,
);

const HarpyThemeData phoenix = HarpyThemeData(
  name: 'phoenix',
  backgroundColors: <int>[0xffd91a1c, 0xffd94700, 0xffd94700, 0xffd91a1c],
  accentColor: 0xffffffc0,
);

const HarpyThemeData harpy = HarpyThemeData(
  name: 'harpy',
  backgroundColors: <int>[0xff40148b, 0xff880E4F],
  accentColor: 0xffff6ffe,
);
