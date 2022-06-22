import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

final materialYouLightProvider = FutureProvider(
  (ref) async {
    final corePalette =
        await DynamicColorPlugin.getCorePalette().handleError(logErrorHandler);

    if (corePalette != null) {
      return HarpyThemeData.fromCorePalette(
        corePalette,
        brightness: Brightness.light,
        name: 'Material You light',
      );
    } else {
      return null;
    }
  },
  name: 'MaterialYouLightProvider',
);

final materialYouDarkProvider = FutureProvider(
  (ref) async {
    final corePalette =
        await DynamicColorPlugin.getCorePalette().handleError(logErrorHandler);

    if (corePalette != null) {
      return HarpyThemeData.fromCorePalette(
        corePalette,
        brightness: Brightness.dark,
        name: 'Material You dark',
      );
    } else {
      return null;
    }
  },
  name: 'MaterialYouDarkProvider',
);
