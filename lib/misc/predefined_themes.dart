import 'package:harpy/harpy_widgets/harpy_widgets.dart';

const List<HarpyThemeData> predefinedThemes = [
  crow,
  swan,
  harpy,
];

const HarpyThemeData crow = HarpyThemeData(
  name: 'crow',
  backgroundColors: <int>[0xff000005, 0xff17233d],
  primaryColor: 0xff2196f3,
  secondaryColor: 0xff2196f3,
);

const HarpyThemeData swan = HarpyThemeData(
  name: 'swan',
  backgroundColors: <int>[0xffffffff],
  primaryColor: 0xff444444,
  secondaryColor: 0xff444444,
);

const HarpyThemeData harpy = HarpyThemeData(
  name: 'harpy',
  backgroundColors: <int>[0xff40148b, 0xff880E4F],
  primaryColor: 0xffff6ffe,
  secondaryColor: 0xffff6ffe,
);
