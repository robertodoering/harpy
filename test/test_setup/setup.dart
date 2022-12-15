import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/main.dart';
import 'package:rby/rby.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'http_overrides.dart';
import 'mocks.dart';

export 'constrains.dart';
export 'devices.dart';
export 'mocks.dart';
export 'prime_assets.dart';
export 'tester_utils.dart';
export 'widget_utils.dart';

Future<void> pumpAppBase(
  WidgetTester tester,
  Widget widget, {
  List<Override> overrides = const [],
}) async {
  WidgetsApp.debugAllowBannerOverride = false;
  HttpOverrides.global = MockHttpOverrides();
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ...overrides,
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          theme: ref.watch(harpyThemeProvider).themeData,
          home: HarpyScaffold(child: widget),
        ),
      ),
    ),
  );
}

Future<Widget> buildAppBase(
  Widget child, {
  Map<String, Object> preferences = const {},
  List<Override>? providerOverrides,
}) async {
  WidgetsApp.debugAllowBannerOverride = false;
  HttpOverrides.global = MockHttpOverrides();
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  SharedPreferences.setMockInitialValues(preferences);
  final sharedPreferences = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      applicationProvider.overrideWithValue(MockApplication()),
      connectivityProvider.overrideWith((ref) => MockConnectivityNotifier()),
      routerProvider.overrideWithValue(
        GoRouter(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (_, state) => RbyPage(
                key: state.pageKey,
                builder: (_) => child,
              ),
            ),
          ],
        ),
      ),
      ...?providerOverrides,
    ],
    child: const HarpyApp(),
  );
}

Future<Widget> buildListItemBase(
  Widget child, {
  Map<String, Object> preferences = const {},
  List<Override>? providerOverrides,
}) async {
  return buildAppBase(
    HarpyScaffold(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [child],
      ),
    ),
    preferences: preferences,
    providerOverrides: providerOverrides,
  );
}
