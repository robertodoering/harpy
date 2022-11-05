import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

part 'timeline_fillter_selection_provider.freezed.dart';

/// Implements common functionality for provider that handle timeline filter
/// selection.
///
/// For example implementations, see:
/// * [homeTimelineFilterProvider]
/// * [userTimelineFilterProvider]
/// * [listTimelineFilterProvider]
abstract class TimelineFilterSelectionNotifier
    extends StateNotifier<TimelineFilterSelectionState> with LoggerMixin {
  TimelineFilterSelectionNotifier({
    required this.ref,
  }) : super(const TimelineFilterSelectionState.initial()) {
    sortTimelineFilters();
  }

  @protected
  final Ref ref;

  /// Whether the filter can have a unique selection.
  @protected
  bool get showUnique;

  /// The display name of a selected filter if it is unique.
  @protected
  String? get uniqueName;

  /// The currently selected active timeline filter or `null` if no filter is
  /// selected.
  @protected
  ActiveTimelineFilter? get activeFilter;

  void selectTimelineFilter(String uuid);

  void removeTimelineFilterSelection();

  void sortTimelineFilters() {
    log.fine('sorting timeline filters');

    final timelineFilterState = ref.read(timelineFilterProvider);

    final selectedTimelineFilter = timelineFilterState.filterByUuid(
      activeFilter?.uuid,
    );

    final sortedTimelineFilters =
        timelineFilterState.timelineFilters.sorted((a, b) {
      // sort currently selected timeline filter first
      if (a == selectedTimelineFilter) {
        return -1;
      } else if (b == selectedTimelineFilter) {
        return 1;
      } else {
        // sort active filters before other filters
        final indexA = timelineFilterState.activeTimelineFilters.indexWhere(
          (activeFilter) => activeFilter.uuid == a.uuid,
        );

        final indexB = timelineFilterState.activeTimelineFilters.indexWhere(
          (activeFilter) => activeFilter.uuid == b.uuid,
        );

        if (indexA != -1 && indexB == -1) {
          return -1;
        } else if (indexA == -1 && indexB != -1) {
          return 1;
        } else {
          return 0;
        }
      }
    });

    final sortedFilters = sortedTimelineFilters
        .map(
          (timelineFilter) => SortedTimelineFilter(
            timelineFilter: timelineFilter,
            appliedFilters: timelineFilterState.activeTimelineFilters.where(
              (activeFilter) => activeFilter.uuid == timelineFilter.uuid,
            ),
            isSelected: timelineFilter == selectedTimelineFilter,
          ),
        )
        .toBuiltList();

    if (sortedFilters.isEmpty) {
      state = const TimelineFilterSelectionState.noFilters();
    } else {
      state = TimelineFilterSelectionState.data(
        sortedFilters: sortedFilters,
        activeFilter: activeFilter,
        showUnique: showUnique,
        uniqueName: uniqueName,
        isUnique: activeFilter?.data != null,
      );
    }
  }

  /// Toggles whether the selection should be unique to the user / list or
  /// generic (for all users / lists).
  ///
  /// If a filter is already selected and the toggle changes to unique, the
  /// currently selected generic filter will also be selected for the new unique
  /// user / list.
  ///
  /// If a filter is already selected and the toggle changes to generic, the
  /// currently selected unique filter will be used as the generic filter.
  void toggleUnique(bool value) {
    log.fine('toggling selection unique $value');

    final currentState = state;

    if (currentState is _Data) {
      final selectedTimelineFilter =
          ref.read(timelineFilterProvider).filterByUuid(
                currentState.activeFilter?.uuid,
              );

      if (selectedTimelineFilter != null) {
        // a filter is already selected

        if (value) {
          // select the already selected (generic) filter again as a unique
          // filter
          state = currentState.copyWith(isUnique: true);
          selectTimelineFilter(selectedTimelineFilter.uuid);
          sortTimelineFilters();
        } else {
          // remove unique filter first and then select it as a generic filter
          removeTimelineFilterSelection();
          state = currentState.copyWith(isUnique: false);
          selectTimelineFilter(selectedTimelineFilter.uuid);
          sortTimelineFilters();
        }
      } else {
        state = currentState.copyWith(isUnique: value);
      }
    }
  }
}

@freezed
class TimelineFilterSelectionState with _$TimelineFilterSelectionState {
  const factory TimelineFilterSelectionState.initial() = _Initial;

  const factory TimelineFilterSelectionState.noFilters() = _NoFilters;

  const factory TimelineFilterSelectionState.data({
    required BuiltList<SortedTimelineFilter> sortedFilters,

    /// The currently selected active filter or `null` if no filter is selected.
    required ActiveTimelineFilter? activeFilter,

    /// Whether the currently selected filter is a unique filter.
    required bool isUnique,

    /// The display name of a selected filter if it is unique.
    required String? uniqueName,

    /// Whether the selection can be unique.
    required bool showUnique,
  }) = _Data;
}

extension StateExtension on TimelineFilterSelectionState {
  bool get isUnique => maybeMap(
        data: (data) => data.isUnique,
        orElse: () => false,
      );
}

@freezed
class SortedTimelineFilter with _$SortedTimelineFilter {
  const factory SortedTimelineFilter({
    required TimelineFilter timelineFilter,

    /// A list of active filters that have the [timelineFilter] applied.
    required Iterable<ActiveTimelineFilter> appliedFilters,
    required bool isSelected,
  }) = _SortedTimelineFilter;
}
