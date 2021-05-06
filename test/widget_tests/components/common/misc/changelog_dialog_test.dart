import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:mockito/mockito.dart';

class MockHarpyNavigator extends Mock implements HarpyNavigator {}

class MockRouteObserver extends Mock
    implements RouteObserver<PageRoute<dynamic>> {}

class MockHarpyPreferences extends Mock implements HarpyPreferences {}

class MockHarpyInfo extends Mock implements HarpyInfo {}

void main() {
  setUp(() {
    app.registerLazySingleton<HarpyNavigator>(() => MockHarpyNavigator());
    app.registerLazySingleton<HarpyInfo>(() => MockHarpyInfo());
    app.registerLazySingleton<HarpyPreferences>(() => MockHarpyPreferences());
    app.registerLazySingleton<ChangelogPreferences>(
      () => ChangelogPreferences(),
    );
    app.registerLazySingleton<ChangelogParser>(() => ChangelogParser());

    when(app<HarpyNavigator>().routeObserver).thenReturn(MockRouteObserver());
  });

  tearDown(app.reset);

  group('changelog dialog with changelog text', () {
    setUp(() {
      ServicesBinding.instance!.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async => utf8.encoder.convert(_changelog).buffer.asByteData(),
      );
    });

    // testWidgets(
    //     'is shown when the home screen is built if the dialog has '
    //     'not been shown in the current version yet',
    //     (WidgetTester tester) async {
    //   when(
    //     app<HarpyPreferences>().getBool('showChangelogDialog', any!),
    //   ).thenAnswer(
    //     (_) => true,
    //   );
    //
    //   when(
    //     app<HarpyPreferences>().getInt('lastShownVersion', any!),
    //   ).thenAnswer(
    //     (_) => 13,
    //   );
    //
    //   when(app<HarpyInfo>().packageInfo).thenReturn(
    //     PackageInfo(
    //       buildNumber: '14',
    //       appName: '',
    //       version: '',
    //       packageName: '',
    //     ),
    //   );
    //
    //   await tester.pumpWidget(const MaterialApp(
    //     home: MockHomeScreen(),
    //   ));
    //
    //   await tester.pumpAndSettle();
    //
    //   expect(find.byType(HarpyDialog), findsOneWidget);
    // });
    //
    // testWidgets('sets the last shown version when its shown',
    //     (WidgetTester tester) async {
    //   when(
    //     app<HarpyPreferences>().getBool('showChangelogDialog', any!),
    //   ).thenAnswer(
    //     (_) => true,
    //   );
    //
    //   when(
    //     app<HarpyPreferences>().getInt('lastShownVersion', any!),
    //   ).thenAnswer(
    //     (_) => 13,
    //   );
    //
    //   when(app<HarpyInfo>().packageInfo).thenReturn(
    //     PackageInfo(
    //       buildNumber: '14',
    //       version: '',
    //       packageName: '',
    //       appName: '',
    //     ),
    //   );
    //
    //   await tester.pumpWidget(const MaterialApp(
    //     home: MockHomeScreen(),
    //   ));
    //
    //   await tester.pumpAndSettle();
    //
    //   expect(find.byType(HarpyDialog), findsOneWidget);
    //
    //   verify(app<HarpyPreferences>().setInt('lastShownVersion', 14));
    // });

    // testWidgets(
    //     'does not show when the last shown version is equal '
    //     'to the current version', (WidgetTester tester) async {
    //   when(
    //     app<HarpyPreferences>().getBool('showChangelogDialog', any!),
    //   ).thenAnswer(
    //     (_) => true,
    //   );
    //
    //   when(
    //     app<HarpyPreferences>().getInt('lastShownVersion', any!),
    //   ).thenAnswer(
    //     (_) => 14,
    //   );
    //
    //   when(app<HarpyInfo>().packageInfo).thenReturn(
    //     PackageInfo(
    //       buildNumber: '14',
    //       version: '',
    //       packageName: '',
    //       appName: '',
    //     ),
    //   );
    //
    //   await tester.pumpWidget(const MaterialApp(
    //     home: MockHomeScreen(),
    //   ));
    //
    //   await tester.pumpAndSettle();
    //
    //   expect(find.byType(HarpyDialog), findsNothing);
    // });

    //   testWidgets(
    //       'does not show when the `showChangelogDialog` settings is
    //       disabled',
    //       (WidgetTester tester) async {
    //     when(
    //       app<HarpyPreferences>().getBool('showChangelogDialog', any!),
    //     ).thenAnswer(
    //       (_) => false,
    //     );
    //
    //     when(
    //       app<HarpyPreferences>().getInt('lastShownVersion', any!),
    //     ).thenAnswer(
    //       (_) => 13,
    //     );
    //
    //     when(app<HarpyInfo>().packageInfo).thenReturn(
    //       PackageInfo(
    //         buildNumber: '14',
    //         version: '',
    //         packageName: '',
    //         appName: '',
    //       ),
    //     );
    //
    //     await tester.pumpWidget(const MaterialApp(
    //       home: MockHomeScreen(),
    //     ));
    //
    //     await tester.pumpAndSettle();
    //
    //     expect(find.byType(HarpyDialog), findsNothing);
    //   });
  });
}

class MockHomeScreen extends StatefulWidget {
  const MockHomeScreen();

  @override
  _MockHomeScreenState createState() => _MockHomeScreenState();
}

class _MockHomeScreenState extends State<MockHomeScreen> {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

const String _changelog = '''
· Added Tweet media download
· Added additional home timeline refresh button
· Changed full-screen media overlay
· Disabled gif autoplay (temporarily)
· Removed expensive overlay transition animation
''';
