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

// TODO: move
const phoneConstrains = BoxConstraints.tightFor(width: 414, height: 896);
const tabletLandscapeConstrains = BoxConstraints.tightFor(
  width: 1366,
  height: 1024,
);
const tabletPortraitConstrains = BoxConstraints.tightFor(
  width: 1024,
  height: 1366,
);

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

// TODO: move
Widget buildSingleSliver(Widget sliver) {
  return CustomScrollView(slivers: [sliver]);
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

/// A function that waits for all [Image] widgets found in the widget tree to
/// finish decoding.
///
/// Copied from https://github.com/eBay/flutter_glove_box/tree/master/packages/golden_toolkit.
Future<void> primeAssets(WidgetTester tester) async {
  final imageElements = find.byType(Image, skipOffstage: false).evaluate();
  final containerElements =
      find.byType(DecoratedBox, skipOffstage: false).evaluate();

  await tester.runAsync(() async {
    for (final imageElement in imageElements) {
      final widget = imageElement.widget;
      if (widget is Image) {
        await precacheImage(widget.image, imageElement);
      }
    }

    for (final container in containerElements) {
      final widget = container.widget as DecoratedBox;
      final decoration = widget.decoration;

      if (decoration is BoxDecoration) {
        if (decoration.image != null) {
          await precacheImage(decoration.image!.image, container);
        }
      }
    }
  });
}

Future<void> primeAssetsAndSettle(WidgetTester tester) async {
  await primeAssets(tester);
  await tester.pumpAndSettle();
}
