import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

import '../../../../../test_setup/data.dart';
import '../../../../../test_setup/setup.dart';

void main() {
  setUp(setupApp);

  tearDown(app.reset);

  group('timeline filter cubit', () {
    group('initialize', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'emits a state with empty filters if no filters are saved in '
        'preferences',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.initialize(),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'loads filters from preferences',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.initialize(),
        setUp: () {
          app<TimelineFilterPreferences>().timelineFilters = [
            jsonEncode(timelineFilter1.toJson()),
            jsonEncode(timelineFilter2.toJson()),
          ];

          app<TimelineFilterPreferences>().activeTimelineFilters = [
            jsonEncode(activeHomeTimelineFilter1.toJson()),
          ];
        },
        expect: () => [
          TimelineFilterState(
            timelineFilters: [timelineFilter1, timelineFilter2].toBuiltList(),
            activeTimelineFilters: [activeHomeTimelineFilter1].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'emits a state with empty filters if the filters saved in '
        "preferences can't be parsed",
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.initialize(),
        setUp: () {
          app<TimelineFilterPreferences>().timelineFilters = ['okay?'];
        },
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        ],
      );
    });

    group('update timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if the filter has no matching filter with the same uuid',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1].toBuiltList(),
          activeTimelineFilters: BuiltList(),
        ),
        act: (cubit) => cubit.updateTimelineFilter(timelineFilter2),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'updates a timeline filter with the matching uuid',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1].toBuiltList(),
          activeTimelineFilters: BuiltList(),
        ),
        act: (cubit) => cubit.updateTimelineFilter(
          timelineFilter1.copyWith(name: 'updated poi'),
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: [
              timelineFilter1.copyWith(name: 'updated poi'),
            ].toBuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        ],
      );
    });

    group('remove timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if the uuid does not have a matching filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1].toBuiltList(),
          activeTimelineFilters: BuiltList(),
        ),
        act: (cubit) => cubit.removeTimelineFilter('aaa'),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active and timeline filters with the matching uuid',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1, timelineFilter2].toBuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            activeHomeTimelineFilter2,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeTimelineFilter('1337'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: [timelineFilter2].toBuiltList(),
            activeTimelineFilters: [activeHomeTimelineFilter2].toBuiltList(),
          ),
        ],
      );
    });

    group('duplicate timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if the uuid does not have a matching filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1].toBuiltList(),
          activeTimelineFilters: BuiltList(),
        ),
        act: (cubit) => cubit.duplicateTimelineFilter('aaa'),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'duplicates a timeline filter with a new uuid',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: [timelineFilter1].toBuiltList(),
          activeTimelineFilters: BuiltList(),
        ),
        act: (cubit) => cubit.duplicateTimelineFilter('1337'),
        verify: (cubit) {
          expect(cubit.state.timelineFilters.length, equals(2));
          expect(
            cubit.state.timelineFilters[0].uuid !=
                cubit.state.timelineFilters[1].uuid,
            isTrue,
          );
        },
      );
    });

    group('select home timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds home timeline filter and persists it',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.selectHomeTimelineFilter('1337'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [activeHomeTimelineFilter1].toBuiltList(),
          ),
        ],
        verify: (cubit) {
          final activeFilterJson = jsonEncode(
            activeHomeTimelineFilter1.toJson(),
          );

          expect(
            app<TimelineFilterPreferences>().activeTimelineFilters,
            [activeFilterJson],
          );
        },
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'changes active home timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [activeHomeTimelineFilter1].toBuiltList(),
        ),
        act: (cubit) => cubit.selectHomeTimelineFilter('1338'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [activeHomeTimelineFilter2].toBuiltList(),
          ),
        ],
      );
    });

    group('select user timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds generic active user timeline filter and persists it',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.selectUserTimelineFilter('1337'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeGenericUserTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
        verify: (cubit) {
          final activeFilterJson = jsonEncode(
            _activeGenericUserTimelineFilter1.toJson(),
          );

          expect(
            app<TimelineFilterPreferences>().activeTimelineFilters,
            [activeFilterJson],
          );
        },
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'changes generic active user timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            _activeGenericUserTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectUserTimelineFilter('1338'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeGenericUserTimelineFilter2,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds active filter for specific user',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.selectUserTimelineFilter(
          '1337',
          user: const UserData(id: '69', handle: 'harpy_app'),
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeSpecificUserTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds active filter for another specific user',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeSpecificUserTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectUserTimelineFilter(
          '1338',
          user: const UserData(id: '2', handle: '@rbydev'),
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeSpecificUserTimelineFilter1,
              _activeSpecificUserTimelineFilter3,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'changes active filter for specific user',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeSpecificUserTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectUserTimelineFilter(
          '1338',
          user: const UserData(id: '69', handle: '@harpy_app'),
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeSpecificUserTimelineFilter2,
            ].toBuiltList(),
          ),
        ],
      );
    });

    group('select list timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds generic active list timeline filter and persists it',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.selectListTimelineFilter('1337'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeGenericListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
        verify: (cubit) {
          final activeFilterJson = jsonEncode(
            _activeGenericListTimelineFilter1.toJson(),
          );

          expect(
            app<TimelineFilterPreferences>().activeTimelineFilters,
            [activeFilterJson],
          );
        },
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'changes generic active list timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            _activeGenericListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectListTimelineFilter('1338'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeGenericListTimelineFilter2,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds active filter for specific list',
        build: TimelineFilterCubit.new,
        act: (cubit) => cubit.selectListTimelineFilter(
          '1337',
          listId: '42',
          listName: 'Flutter',
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'adds active filter for another specific list',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectListTimelineFilter(
          '1338',
          listId: '666',
          listName: 'Untitled List',
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeSpecificListTimelineFilter1,
              activeSpecificListTimelineFilter3,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'changes active filter for specific list',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.selectListTimelineFilter(
          '1338',
          listId: '42',
          listName: 'Flutter',
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeSpecificListTimelineFilter2,
            ].toBuiltList(),
          ),
        ],
      );
    });

    group('remove home timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if no active home timeline filter exists',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeHomeTimelineFilter(),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active home timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeHomeTimelineFilter(),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              _activeGenericUserTimelineFilter1,
              activeSpecificUserTimelineFilter1,
              _activeGenericListTimelineFilter1,
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );
    });

    group('remove user timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if no active generic user timeline exists',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeUserTimelineFilter(),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active generic user timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeUserTimelineFilter(),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeHomeTimelineFilter1,
              activeSpecificUserTimelineFilter1,
              _activeGenericListTimelineFilter1,
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if no matching active specific user timeline filter '
        'exists',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeUserTimelineFilter(
          user: const UserData(handle: '@rbydev', id: '2'),
        ),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active specific user timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeSpecificUserTimelineFilter3,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeUserTimelineFilter(
          user: const UserData(handle: '@rbydev', id: '2'),
        ),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeHomeTimelineFilter1,
              _activeGenericUserTimelineFilter1,
              activeSpecificUserTimelineFilter1,
              _activeGenericListTimelineFilter1,
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );
    });

    group('remove list timeline filter', () {
      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if no active generic list timeline exists',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeListTimelineFilter(),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active generic list timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeListTimelineFilter(),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeHomeTimelineFilter1,
              _activeGenericUserTimelineFilter1,
              activeSpecificUserTimelineFilter1,
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'does nothing if no matching active specific list timeline filter '
        'exists',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeListTimelineFilter(listId: '666'),
        expect: () => <TimelineFilterState>[],
      );

      blocTest<TimelineFilterCubit, TimelineFilterState>(
        'removes active specific list timeline filter',
        build: TimelineFilterCubit.new,
        seed: () => TimelineFilterState(
          timelineFilters: BuiltList(),
          activeTimelineFilters: [
            activeHomeTimelineFilter1,
            _activeGenericUserTimelineFilter1,
            activeSpecificUserTimelineFilter1,
            _activeGenericListTimelineFilter1,
            _activeSpecificListTimelineFilter1,
            activeSpecificListTimelineFilter3,
          ].toBuiltList(),
        ),
        act: (cubit) => cubit.removeListTimelineFilter(listId: '666'),
        expect: () => [
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: [
              activeHomeTimelineFilter1,
              _activeGenericUserTimelineFilter1,
              activeSpecificUserTimelineFilter1,
              _activeGenericListTimelineFilter1,
              _activeSpecificListTimelineFilter1,
            ].toBuiltList(),
          ),
        ],
      );
    });
  });
}

const _activeGenericUserTimelineFilter1 = ActiveTimelineFilter(
  uuid: '1337',
  type: TimelineFilterType.user,
);

const _activeSpecificUserTimelineFilter2 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.user,
  data: TimelineFilterData.user(handle: '@harpy_app', id: '69'),
);

const _activeSpecificUserTimelineFilter3 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.user,
  data: TimelineFilterData.user(handle: '@rbydev', id: '2'),
);

const _activeGenericListTimelineFilter1 = ActiveTimelineFilter(
  uuid: '1337',
  type: TimelineFilterType.list,
);

const _activeSpecificListTimelineFilter1 = ActiveTimelineFilter(
  uuid: '1337',
  type: TimelineFilterType.list,
  data: TimelineFilterData.list(name: 'Flutter', id: '42'),
);
