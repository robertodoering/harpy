import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

const predefinedThemes = [
  crow,
  swan,
  harpy,
  if (Harpy.isPro) ...predefinedProThemes,
];

const predefinedProThemes = [
  nord,
  dracula,
  monokai,
];

const HarpyThemeData crow = HarpyThemeData(
  name: 'crow',
  backgroundColors: [0xff00030F, 0xff12254A],
  primaryColor: 0xfff3aa2f,
  secondaryColor: 0xff4689ff,
  cardColor: 0x161c85df,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);

const HarpyThemeData swan = HarpyThemeData(
  name: 'swan',
  backgroundColors: [0xffffffff],
  primaryColor: 0xff216eee,
  secondaryColor: 0xff4b8bfd,
  cardColor: 0x14618de3,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);

const HarpyThemeData harpy = HarpyThemeData(
  name: 'harpy',
  backgroundColors: [0xff4f148b, 0xff880E4F],
  primaryColor: 0xffff6ffe,
  secondaryColor: 0xffd570ff,
  cardColor: 0x16ff75ed,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);

const HarpyThemeData nord = HarpyThemeData(
  name: 'nord',
  backgroundColors: [0xff2E3440],
  primaryColor: 0xff5E81AC,
  secondaryColor: 0xff88C0D0,
  cardColor: 0x385e81ac,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);

const HarpyThemeData dracula = HarpyThemeData(
  name: 'dracula',
  backgroundColors: [0xff282A36],
  primaryColor: 0xffBD93F9,
  secondaryColor: 0xffCAA9FA,
  cardColor: 0x28BD93F9,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);

const HarpyThemeData monokai = HarpyThemeData(
  name: 'monokai',
  backgroundColors: [0xff101010],
  primaryColor: 0xff66aa11,
  secondaryColor: 0xffff0090,
  cardColor: 0x283579a8,
  statusBarColor: 0x0,
  navBarColor: 0x0,
);
