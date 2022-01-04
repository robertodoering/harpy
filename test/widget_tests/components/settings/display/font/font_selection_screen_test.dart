import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

import '../../../../../test_setup/setup.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    await setupApp();
  });

  tearDown(app.reset);

  group('font selection screen', () {
    testGoldens(
      'builds with selected font',
      (tester) async {
        await tester.pumpWidgetBuilder(
          FontSelectionScreen(
            title: 'select a body font',
            selectedFont: 'OpenSans',
            onChanged: (_) {},
          ),
          wrapper: buildAppBase,
          surfaceSize: Device.phone.size,
        );

        await tester.pumpAndSettle();

        await screenMatchesGolden(tester, 'font_selection_screen');

        final title = find.text('select a body font');
        final fontCard = find.byType(FontCard);

        expect(title, findsOneWidget);
        expect(fontCard, findsWidgets);
      },
    );

    testGoldens(
      'changes selection on font card tap',
      (tester) async {
        await tester.pumpWidgetBuilder(
          FontSelectionScreen(
            title: 'select a body font',
            selectedFont: 'OpenSans',
            onChanged: (_) {},
          ),
          wrapper: buildAppBase,
          surfaceSize: Device.phone.size,
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(FontCard).at(1));

        await screenMatchesGolden(
          tester,
          'font_selection_screen_changed_selection',
        );

        final fontCard = find.byType(FontCard);

        expect(fontCard, findsWidgets);
      },
    );

    testGoldens(
      'search filters google fonts',
      (tester) async {
        await tester.pumpWidgetBuilder(
          FontSelectionScreen(
            title: 'select a body font',
            selectedFont: 'OpenSans',
            onChanged: (_) {},
          ),
          wrapper: buildAppBase,
          surfaceSize: Device.phone.size,
        );

        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'rob');

        await screenMatchesGolden(
          tester,
          'font_selection_screen_filtered',
        );

        final robotoFont = find.text('Roboto');

        expect(robotoFont, findsOneWidget);
      },
    );
  });
}
