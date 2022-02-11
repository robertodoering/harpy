import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_setup/devices.dart';
import '../../../test_setup/setup.dart';

void main() {
  setUpAll(loadAppFonts);

  group('login page', () {
    testGoldens('builds login page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidgetBuilder(
        const LoginPage(),
        wrapper: (child) => buildAppBase(
          child,
          sharedPreferences: sharedPreferences,
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'login_page_portrait');

      expect(
        tester.widgetList(find.byType(FlareAnimation)),
        [
          isA<FlareAnimation>()
              .having((s) => s.name, 'name', 'harpy_title')
              .having((s) => s.color, 'color', Colors.white),
          isA<FlareAnimation>().having((s) => s.name, 'name', 'harpy_logo'),
        ],
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testGoldens('builds login page with light theme', (tester) async {
      SharedPreferences.setMockInitialValues({'lightThemeId': 1});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidgetBuilder(
        const LoginPage(),
        wrapper: (child) => buildAppBase(
          child,
          sharedPreferences: sharedPreferences,
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'login_page_portrait_light');

      expect(
        tester.widgetList(find.byType(FlareAnimation)),
        [
          isA<FlareAnimation>()
              .having((s) => s.name, 'name', 'harpy_title')
              .having((s) => s.color, 'color', Colors.black),
          isA<FlareAnimation>().having((s) => s.name, 'name', 'harpy_logo'),
        ],
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testGoldens('builds login page in landscape', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidgetBuilder(
        const LoginPage(),
        wrapper: (child) => buildAppBase(
          child,
          sharedPreferences: sharedPreferences,
        ),
        surfaceSize: phoneLandscape.size,
      );

      await screenMatchesGolden(tester, 'login_page_landscape');

      expect(find.byType(FlareAnimation), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
