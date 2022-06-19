import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/components/changelog/widget/changelog_widget.dart';
import 'package:harpy/components/components.dart';

import '../../test_setup/data/changelog_data.dart';
import '../../test_setup/setup.dart';

void main() {
  setUpAll(loadAppFonts);

  group('changelog widget', () {
    testGoldens(
      'builds a changelog widget for a full changelog',
      (tester) async {
        await tester.pumpWidgetBuilder(
          ChangelogWidget(data: changelogFull),
          wrapper: buildListItemBase,
          surfaceSize: Device.phone.size,
        );

        await screenMatchesGolden(tester, 'changelog_widget_full');

        expect(find.text(changelogFull.title!), findsOneWidget);
        for (final line in changelogFull.summary) {
          expect(find.text(line, findRichText: true), findsOneWidget);
        }
        for (final entry in changelogFull.entries) {
          expect(find.text(entry.line, findRichText: true), findsOneWidget);
        }
      },
    );

    testGoldens(
      'builds a changelog widget with rich markdown formatted text',
      (tester) async {
        await tester.pumpWidgetBuilder(
          ChangelogWidget(data: changelogRich),
          wrapper: buildListItemBase,
          surfaceSize: Device.phone.size,
        );

        await screenMatchesGolden(tester, 'changelog_widget_rich');

        expect(
          find.text('Check out harpy on GitHub!', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.text('Added feature thanks (@harpy_app)', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.text('In settings › general', findRichText: true),
          findsOneWidget,
        );
      },
    );
  });
}
