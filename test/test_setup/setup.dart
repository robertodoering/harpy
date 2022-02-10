import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'http_overrides.dart';
import 'mocks.dart';

Future<Widget> buildAppBase({
  required Widget child,
  List<Override>? providerOverrides,
  Map<String, Object> initialMockValues = const <String, Object>{},
}) async {
  HttpOverrides.global = MockHttpOverrides();
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  SharedPreferences.setMockInitialValues(initialMockValues);
  final sharedPreferences = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      applicationProvider.overrideWithValue(MockApplication()),
      routesProvider.overrideWithValue([
        GoRoute(
          path: '/',
          pageBuilder: (_, state) => HarpyPage(
            key: state.pageKey,
            child: child,
          ),
        ),
      ]),
      ...?providerOverrides,
    ],
    child: const HarpyApp(),
  );
}
