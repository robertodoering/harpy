import 'package:built_collection/built_collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'timeline_filter_selection_cubit.freezed.dart';

/// Implements common functionality for cubits that handle timeline filter
/// selection.
///
/// For example implementations, see:
/// * [HomeTimelineFilterCubit]
/// * [UserTimelineFilterCubit]
/// * [ListTimelineFilterCubit]
abstract class TimelineFilterSelectionCubit
    extends Cubit<TimelineFilterSelectionState> with HarpyLogger {
  TimelineFilterSelectionCubit({
    required this.timelineFilterCubit,
  }) : super(const TimelineFilterSelectionState.initial()) {
    sortTimelineFilters();
  }

  @protected
  final TimelineFilterCubit timelineFilterCubit;

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

    final timelineFilterState = timelineFilterCubit.state;

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
      emit(const TimelineFilterSelectionState.noFilters());
    } else {
      emit(
        TimelineFilterSelectionState.data(
          sortedFilters: sortedFilters,
          activeFilter: activeFilter,
          showUnique: showUnique,
          uniqueName: uniqueName,
          isUnique: activeFilter?.data != null,
        ),
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
      final timelineFilterState = timelineFilterCubit.state;

      final selectedTimelineFilter = timelineFilterState.filterByUuid(
        currentState.activeFilter?.uuid,
      );

      if (selectedTimelineFilter != null) {
        // a filter is already selected

        if (value) {
          // select the already selected (generic) filter again as a unique
          // filter
          emit(currentState.copyWith(isUnique: true));
          selectTimelineFilter(selectedTimelineFilter.uuid);
          sortTimelineFilters();
        } else {
          // remove unique filter first and then select it as a generic filter
          removeTimelineFilterSelection();
          emit(currentState.copyWith(isUnique: false));
          selectTimelineFilter(selectedTimelineFilter.uuid);
          sortTimelineFilters();
        }
      } else {
        emit(currentState.copyWith(isUnique: value));
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
