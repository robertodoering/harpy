import 'package:built_collection/built_collection.dart';
import 'package:harpy/core/core.dart';

final predefinedThemes = [
  _crow, // 0 -> default dark theme
  _swan, // 1 -> default light theme
  _harpy,
  if (isPro) ...predefinedProThemes,
];

final predefinedProThemes = [
  _nord,
  _dracula,
  _monokai,
];

final _crow = HarpyThemeData(
  name: 'crow',
  backgroundColors: [0xff00030F, 0xff12254A].toBuiltList(),
  primaryColor: 0xfff3aa2f,
  secondaryColor: 0xff4689ff,
  cardColor: 0x161c85df,
  statusBarColor: 0x0000030F,
  navBarColor: 0x0012254A,
);

final _swan = HarpyThemeData(
  name: 'swan',
  backgroundColors: [0xffffffff].toBuiltList(),
  primaryColor: 0xff216eee,
  secondaryColor: 0xff4b8bfd,
  cardColor: 0x14618de3,
  statusBarColor: 0x00ffffff,
  navBarColor: 0x00ffffff,
);

final _harpy = HarpyThemeData(
  name: 'harpy',
  backgroundColors: [0xff4f148b, 0xff880E4F].toBuiltList(),
  primaryColor: 0xffff6ffe,
  secondaryColor: 0xffd570ff,
  cardColor: 0x16ff75ed,
  statusBarColor: 0x004f148b,
  navBarColor: 0x00880E4F,
);

final _nord = HarpyThemeData(
  name: 'nord',
  backgroundColors: [0xff2E3440].toBuiltList(),
  primaryColor: 0xff5E81AC,
  secondaryColor: 0xff88C0D0,
  cardColor: 0x385e81ac,
  statusBarColor: 0x002E3440,
  navBarColor: 0x002E3440,
);

final _dracula = HarpyThemeData(
  name: 'dracula',
  backgroundColors: [0xff282A36].toBuiltList(),
  primaryColor: 0xffBD93F9,
  secondaryColor: 0xffCAA9FA,
  cardColor: 0x28BD93F9,
  statusBarColor: 0x00282A36,
  navBarColor: 0x00282A36,
);

final _monokai = HarpyThemeData(
  name: 'monokai',
  backgroundColors: [0xff101010].toBuiltList(),
  primaryColor: 0xff66aa11,
  secondaryColor: 0xffff0090,
  cardColor: 0x283579a8,
  statusBarColor: 0x00101010,
  navBarColor: 0x00101010,
);
