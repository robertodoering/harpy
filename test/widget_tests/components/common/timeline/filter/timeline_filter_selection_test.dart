import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

import '../../../../../test_setup/data.dart';
import '../../../../../test_setup/setup.dart';

void main() {
  setUpAll(loadAppFonts);

  setUp(setupApp);

  tearDown(app.reset);

  group('timeline filter selection', () {
    testGoldens(
        'builds a center `add new filter` button when no timeline '
        'filters exist', (tester) async {
      await tester.pumpWidgetBuilder(
        TimelineFilterSelection(
          blocBuilder: (context) => HomeTimelineFilterCubit(
            timelineFilterCubit: context.read(),
          ),
        ),
        wrapper: buildAppBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'no_timeline_filters');

      final centeredButton = find.descendant(
        of: find.byType(Center),
        matching: find.text('add new filter'),
      );

      expect(centeredButton, findsOneWidget);
    });

    testGoldens('builds timeline filter cards for each filter', (tester) async {
      await tester.pumpWidgetBuilder(
        TimelineFilterSelection(
          blocBuilder: (context) => HomeTimelineFilterCubit(
            timelineFilterCubit: context.read(),
          ),
        ),
        wrapper: (child) => buildAppBase(
          child,
          timelineFilterState: TimelineFilterState(
            timelineFilters: [
              timelineFilter1,
              timelineFilter2,
            ].toBuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'with_timeline_filters');

      final filter1 = find.descendant(
        of: find.byType(TimelineFilterCard),
        matching: find.text('poi'),
      );

      final filter2 = find.descendant(
        of: find.byType(TimelineFilterCard),
        matching: find.text('poi'),
      );

      expect(filter1, findsOneWidget);
      expect(filter2, findsOneWidget);
    });

    testGoldens('builds timeline filter cards with active and selected filter',
        (tester) async {
      await tester.pumpWidgetBuilder(
        TimelineFilterSelection(
          blocBuilder: (context) => HomeTimelineFilterCubit(
            timelineFilterCubit: context.read(),
          ),
        ),
        wrapper: (child) => buildAppBase(
          child,
          timelineFilterState: TimelineFilterState(
            timelineFilters: [
              timelineFilter1,
              timelineFilter2,
            ].toBuiltList(),
            activeTimelineFilters: [
              activeHomeTimelineFilter1,
              activeGenericUserTimelineFilter2,
              activeSpecificUserTimelineFilter1,
              activeGenericListTimelineFilter2,
              activeSpecificListTimelineFilter2,
              activeSpecificListTimelineFilter3,
            ].toBuiltList(),
          ),
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'with_selected_timeline_filters');

      final filter1 = find.descendant(
        of: find.byType(TimelineFilterCard),
        matching: find.text('poi'),
      );

      final filter2 = find.descendant(
        of: find.byType(TimelineFilterCard),
        matching: find.text('poi'),
      );

      expect(filter1, findsOneWidget);
      expect(filter2, findsOneWidget);
    });
  });
}
