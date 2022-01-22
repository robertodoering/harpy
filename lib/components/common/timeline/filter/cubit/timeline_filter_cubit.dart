import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:uuid/uuid.dart';

part 'timeline_filter_cubit.freezed.dart';

/// A global cubit that handles parsing, persisting and updating
/// [TimelineFilter]s and [ActiveTimelineFilter]s, which can be used to filter
/// timelines throughout harpy.
///
/// A [TimelineFilter] describes the attributes and behavior of a single filter
/// and can used and shared across multiple timelines. Changes to the filter
/// will sync across its timelines.
///
/// A [ActiveTimelineFilter] matches a timeline and its timeline filter. Some
/// timelines can have unique filters based on a criteria (e.g. a user timeline
/// can have a unique filters based on the user id).
class TimelineFilterCubit extends Cubit<TimelineFilterState> with HarpyLogger {
  TimelineFilterCubit()
      : super(
          TimelineFilterState(
            timelineFilters: BuiltList(),
            activeTimelineFilters: BuiltList(),
          ),
        );

  void initialize() {
    final timelineFilters = <TimelineFilter>[];
    final activeTimelineFilters = <ActiveTimelineFilter>[];

    try {
      // decode timeline filter
      timelineFilters.addAll(
        app<TimelineFilterPreferences>()
            .timelineFilters
            .map<dynamic>(jsonDecode)
            .whereType<Map<String, dynamic>>()
            .map<TimelineFilter>(TimelineFilter.fromJson),
      );

      // decode active timeline filter
      activeTimelineFilters.addAll(
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
        timelineFilters: timelineFilters.toBuiltList(),
        activeTimelineFilters: activeTimelineFilters.toBuiltList(),
      ),
    );
  }

  void addTimelineFilter(TimelineFilter timelineFilter) {
    emit(
      state.copyWith(
        timelineFilters: state.timelineFilters.rebuild(
          (builder) => builder.add(timelineFilter),
        ),
      ),
    );

    _persist();
  }

  /// Updates the timeline filter with the same uuid as the [timelineFilter].
  void updateTimelineFilter(TimelineFilter timelineFilter) {
    final index = state.timelineFilters.indexWhere(
      (filter) => filter.uuid == timelineFilter.uuid,
    );

    if (index != -1) {
      emit(
        state.copyWith(
          timelineFilters: state.timelineFilters.rebuild(
            (builder) => builder[index] = timelineFilter,
          ),
        ),
      );

      _persist();
    }
  }

  /// Removes the timeline filter for the [uuid].
  ///
  /// Any active timeline filters referencing this filter will also be removed.
  void removeTimelineFilter(String uuid) {
    emit(
      state.copyWith(
        timelineFilters: state.timelineFilters.rebuild(
          (builder) => builder.removeWhere((filter) => filter.uuid == uuid),
        ),
        activeTimelineFilters: state.activeTimelineFilters.rebuild(
          (builder) => builder.removeWhere((filter) => filter.uuid == uuid),
        ),
      ),
    );

    _persist();
  }

  /// Adds a copy of the matching timeline filter with a new uuid.
  void duplicateTimelineFilter(String uuid) {
    final timelineFilter = state.timelineFilters.firstWhereOrNull(
      (filter) => filter.uuid == uuid,
    );

    if (timelineFilter != null) {
      addTimelineFilter(timelineFilter.copyWith(uuid: const Uuid().v4()));
    }
  }

  /// Creates a new active timeline filter for the home timeline or overrides an
  /// existing selection.
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

  /// Creates a new active timeline filter for the user timeline or overrides an
  /// existing one.
  ///
  /// If [user] is `null`, the active timeline filter will be used as a generic
  /// timeline filter for all users.
  /// Otherwise the filter will only be active for the unique user.
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
      // find unique user filter
      index = activeTimelineFilters.indexWhere(
        (filter) =>
            filter.type == TimelineFilterType.user &&
            filter.data is TimelineFilterDataUser &&
            filter.data?.id == user.id,
      );
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

  /// Creates a new active timeline filter for the list timeline or overrides an
  /// existing one.
  ///
  /// If [listId] or listNameis `null`, the active timeline filter will be used
  /// as a generic timeline filter for all lists.
  /// Otherwise the filter will only be active for the unique list.
  void selectListTimelineFilter(
    String uuid, {
    String? listId,
    String? listName,
  }) {
    final newActiveFilter = ActiveTimelineFilter(
      uuid: uuid,
      type: TimelineFilterType.list,
      data: listId == null || listName == null
          ? null
          : TimelineFilterData.list(name: listName, id: listId),
    );

    final activeTimelineFilters = state.activeTimelineFilters.toList();

    int index;

    if (listId == null || listName == null) {
      // find generic list filter
      index = activeTimelineFilters.indexWhere(
        (filter) =>
            filter.type == TimelineFilterType.list && filter.data == null,
      );
    } else {
      // find unique list filter
      index = activeTimelineFilters.indexWhere(
        (filter) =>
            filter.type == TimelineFilterType.list &&
            filter.data is TimelineFilterDataList &&
            filter.data?.id == listId,
      );
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
  /// If a [listId] is specified, only the list timeline filter for the list is
  /// removed.
  void removeListTimelineFilter({String? listId}) {
    if (listId == null) {
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
                    filter.data?.id == listId,
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
  TimelineFilter? filterByUuid(String? uuid) => uuid == null
      ? null
      : timelineFilters.firstWhereOrNull((filter) => filter.uuid == uuid);

  /// Returns the currently active home timeline filter.
  ActiveTimelineFilter? activeHomeFilter() =>
      activeTimelineFilters.firstWhereOrNull(
        (filter) => filter.type == TimelineFilterType.home,
      );

  /// Returns the currently active user timeline filter for the [userId].
  ActiveTimelineFilter? activeUserFilter(String userId) =>
      // unique filter
      activeTimelineFilters
          .where(
            (filter) =>
                filter.type == TimelineFilterType.user &&
                filter.data is TimelineFilterDataUser,
          )
          .firstWhereOrNull((filter) => filter.data?.id == userId) ??
      // generic filter
      activeTimelineFilters.firstWhereOrNull(
        (filter) =>
            filter.type == TimelineFilterType.user && filter.data == null,
      );

  /// Returns the currently active list timeline filter for the [listId].
  ActiveTimelineFilter? activeListFilter(String listId) =>
      // unique filter
      activeTimelineFilters
          .where(
            (filter) =>
                filter.type == TimelineFilterType.list &&
                filter.data is TimelineFilterDataList,
          )
          .firstWhereOrNull((filter) => filter.data?.id == listId) ??
      // generic filter
      activeTimelineFilters.firstWhereOrNull(
        (filter) =>
            filter.type == TimelineFilterType.list && filter.data == null,
      );

  /// Returns the [TimelineFilter] for the home timeline.
  TimelineFilter? homeFilter() => filterByUuid(activeHomeFilter()?.uuid);

  /// Returns the [TimelineFilter] for the user timeline.
  TimelineFilter? userFilter(String userId) =>
      filterByUuid(activeUserFilter(userId)?.uuid);

  /// Returns the [TimelineFilter] for the list timeline.
  TimelineFilter? listFilter(String listId) =>
      filterByUuid(activeListFilter(listId)?.uuid);
}
