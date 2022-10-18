import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final corePaletteProvider = FutureProvider(
  (ref) => DynamicColorPlugin.getCorePalette().handleError(logErrorHandler),
  name: 'CorePaletteProvider',
);

final materialYouLightProvider = FutureProvider(
  (ref) async {
    final corePalette = ref.watch(corePaletteProvider).asData?.value;

    return corePalette != null
        ? HarpyThemeData.fromCorePalette(
            corePalette,
            brightness: Brightness.light,
            name: 'Material You · light',
          )
        : null;
  },
  name: 'MaterialYouLightProvider',
);

final materialYouDarkProvider = FutureProvider(
  (ref) async {
    final corePalette = ref.watch(corePaletteProvider).asData?.value;

    return corePalette != null
        ? HarpyThemeData.fromCorePalette(
            corePalette,
            brightness: Brightness.dark,
            name: 'Material You · dark',
          )
        : null;
  },
  name: 'MaterialYouDarkProvider',
);
