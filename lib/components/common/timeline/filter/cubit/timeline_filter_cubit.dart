import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'timeline_filter_cubit.freezed.dart';

class TimelineFilterCubit extends Cubit<TimelineFilterState> with HarpyLogger {
  TimelineFilterCubit()
      : super(
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        ) {
    _initialize();
  }

  void _initialize() {
    final timelineFilter = <TimelineFilter>[];
    final activeTimelineFilter = <ActiveTimelineFilter>[];

    try {
      // decode timeline filter
      timelineFilter.addAll(
        app<TimelineFilterPreferences>()
            .timelineFilters
            .map<dynamic>(jsonDecode)
            .whereType<Map<String, dynamic>>()
            .map<TimelineFilter>(TimelineFilter.fromJson),
      );

      // decode active timeline filter
      activeTimelineFilter.addAll(
        app<TimelineFilterPreferences>()
            .activeTimelineFilters
            .map<dynamic>(jsonDecode)
            .whereType<Map<String, dynamic>>()
            .map<ActiveTimelineFilter>(ActiveTimelineFilter.fromJson),
      );
    } catch (e, st) {
      log.severe('unable to decode timeline filter', e, st);
    }

    emit(
      TimelineFilterState(
        timelineFilters: timelineFilter.toBuiltList(),
        activeTimelineFilters: activeTimelineFilter.toBuiltList(),
      ),
    );
  }

  void selectHomeTimelineFilter(String uuid) {
    final newActiveFilter = ActiveTimelineFilter(
      uuid: uuid,
      type: TimelineFilterType.home,
    );

    final activeTimelineFilters = state.activeTimelineFilters.toList();

    final index = activeTimelineFilters.indexWhere(
      (filter) => filter.type == TimelineFilterType.home,
    );

    if (index == -1) {
      activeTimelineFilters.add(newActiveFilter);
    } else {
      activeTimelineFilters[index] = newActiveFilter;
    }

    emit(
      state.copyWith(
        activeTimelineFilters: activeTimelineFilters.toBuiltList(),
      ),
    );

    _persist();
  }

  void selectUserTimelineFilter(String uuid, {UserData? user}) {
    final newActiveFilter = ActiveTimelineFilter(
      uuid: uuid,
      type: TimelineFilterType.user,
      data: user == null
          ? null
          : TimelineFilterData.user(handle: user.handle, id: user.id),
    );

    final activeTimelineFilters = state.activeTimelineFilters.toList();

    int index;

    if (user == null) {
      // find generic user filter
      index = activeTimelineFilters.indexWhere(
        (filter) =>
            filter.type == TimelineFilterType.user && filter.data == null,
      );
    } else {
      // find specific user filter
      index = activeTimelineFilters
          .where(
            (filter) =>
                filter.type == TimelineFilterType.user &&
                filter.data is TimelineFilterDataUser,
          )
          .toList()
          .indexWhere((filter) => filter.data?.id == user.id);
    }

    if (index == -1) {
      activeTimelineFilters.add(newActiveFilter);
    } else {
      activeTimelineFilters[index] = newActiveFilter;
    }

    emit(
      state.copyWith(
        activeTimelineFilters: activeTimelineFilters.toBuiltList(),
      ),
    );

    _persist();
  }

  void selectListTimelineFilter(String uuid, {TwitterListData? list}) {
    final newActiveFilter = ActiveTimelineFilter(
      uuid: uuid,
      type: TimelineFilterType.list,
      data: list == null
          ? null
          : TimelineFilterData.list(name: list.name, id: list.id),
    );

    final activeTimelineFilters = state.activeTimelineFilters.toList();

    int index;

    if (list == null) {
      // find generic list filter
      index = activeTimelineFilters.indexWhere(
        (filter) =>
            filter.type == TimelineFilterType.list && filter.data == null,
      );
    } else {
      // find specific list filter
      index = activeTimelineFilters
          .where(
            (filter) =>
                filter.type == TimelineFilterType.list &&
                filter.data is TimelineFilterDataList,
          )
          .toList()
          .indexWhere((filter) => filter.data?.id == list.id);
    }

    if (index == -1) {
      activeTimelineFilters.add(newActiveFilter);
    } else {
      activeTimelineFilters[index] = newActiveFilter;
    }

    emit(
      state.copyWith(
        activeTimelineFilters: activeTimelineFilters.toBuiltList(),
      ),
    );

    _persist();
  }

  /// Removes the home timeline filter from the active timeline filters.
  void removeHomeTimelineFilter() {
    emit(
      state.copyWith(
        activeTimelineFilters: state.activeTimelineFilters
            .whereNot((filter) => filter.type == TimelineFilterType.home)
            .toBuiltList(),
      ),
    );

    _persist();
  }

  /// Removes the user timeline filter from the active timeline filters.
  ///
  /// If a [user] is specified, only the user timeline filter for the user is
  /// removed.
  void removeUserTimelineFilter({UserData? user}) {
    if (user == null) {
      emit(
        state.copyWith(
          activeTimelineFilters: state.activeTimelineFilters
              .whereNot(
                (filter) =>
                    filter.type == TimelineFilterType.user &&
                    filter.data == null,
              )
              .toBuiltList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          activeTimelineFilters: state.activeTimelineFilters
              .whereNot(
                (filter) =>
                    filter.type == TimelineFilterType.user &&
                    filter.data?.id == user.id,
              )
              .toBuiltList(),
        ),
      );
    }

    _persist();
  }

  /// Removes the list timeline filter from the active timeline filters.
  ///
  /// If a [list] is specified, only the list timeline filter for the list is
  /// removed.
  void removeListTimelineFilter({TwitterListData? list}) {
    if (list == null) {
      emit(
        state.copyWith(
          activeTimelineFilters: state.activeTimelineFilters
              .whereNot(
                (filter) =>
                    filter.type == TimelineFilterType.list &&
                    filter.data == null,
              )
              .toBuiltList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          activeTimelineFilters: state.activeTimelineFilters
              .whereNot(
                (filter) =>
                    filter.type == TimelineFilterType.list &&
                    filter.data?.id == list.id,
              )
              .toBuiltList(),
        ),
      );
    }

    _persist();
  }

  void _persist() {
    try {
      final timelineFiltersJson = state.timelineFilters
          .map((filter) => filter.toJson())
          .map(jsonEncode)
          .toList();

      final activeTimelineFiltersJson = state.activeTimelineFilters
          .map((filter) => filter.toJson())
          .map(jsonEncode)
          .toList();

      app<TimelineFilterPreferences>().timelineFilters = timelineFiltersJson;
      app<TimelineFilterPreferences>().activeTimelineFilters =
          activeTimelineFiltersJson;
    } catch (e, st) {
      log.severe('unable to encode timeline filter', e, st);
    }
  }
}

@freezed
class TimelineFilterState with _$TimelineFilterState {
  const factory TimelineFilterState({
    required BuiltList<TimelineFilter> timelineFilters,
    required BuiltList<ActiveTimelineFilter> activeTimelineFilters,
  }) = _TimelineFilterState;
}

extension TimelineFilterStateExtension on TimelineFilterState {
  TimelineFilter? timelineFilterByUuid(String uuid) =>
      timelineFilters.firstWhereOrNull((filter) => filter.uuid == uuid);

  TimelineFilter? get homeTimelineFilter {
    final activeFilter = activeTimelineFilters.firstWhereOrNull(
      (filter) => filter.type == TimelineFilterType.home,
    );

    if (activeFilter != null) {
      return timelineFilterByUuid(activeFilter.uuid);
    } else {
      return null;
    }
  }

  TimelineFilter? userTimelineFilter(UserData user) {
    final userFilter = activeTimelineFilters
        .where(
          (filter) =>
              filter.type == TimelineFilterType.user &&
              filter.data is TimelineFilterDataUser,
        )
        .firstWhereOrNull((filter) => filter.data?.id == user.id);

    if (userFilter != null) {
      return timelineFilterByUuid(userFilter.uuid);
    } else {
      // if the user has no specific filter, we return the generic user
      // timeline filter or null if no filter for users exist

      final genericFilter = activeTimelineFilters.firstWhereOrNull(
        (filter) =>
            filter.type == TimelineFilterType.user && filter.data == null,
      );

      if (genericFilter != null) {
        return timelineFilterByUuid(genericFilter.uuid);
      } else {
        return null;
      }
    }
  }

  TimelineFilter? listTimelineFilter(TwitterListData list) {
    final listFilter = activeTimelineFilters
        .where(
          (filter) =>
              filter.type == TimelineFilterType.list &&
              filter.data is TimelineFilterDataList,
        )
        .firstWhereOrNull((filter) => filter.data?.id == list.id);

    if (listFilter != null) {
      return timelineFilterByUuid(listFilter.uuid);
    } else {
      // if the list has no specific filter, we return the generic lits
      // timeline filter or null if no filter for lists exist

      final genericFilter = activeTimelineFilters.firstWhereOrNull(
        (filter) =>
            filter.type == TimelineFilterType.list && filter.data == null,
      );

      if (genericFilter != null) {
        return timelineFilterByUuid(genericFilter.uuid);
      } else {
        return null;
      }
    }
  }
}
