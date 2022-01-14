import 'package:built_collection/built_collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

part 'timeline_filter_selection_cubit.freezed.dart';

class TimelineFilterSelectionCubit extends Cubit<TimelineFilterSelectionState> {
  TimelineFilterSelectionCubit({
    required TimelineFilterCubit timelineFilterCubit,
    required TimelineFilterType? type,
    required UserData? user,
    required TwitterListData? list,
  })  : _timelineFilterCubit = timelineFilterCubit,
        _type = type,
        _user = user,
        _list = list,
        super(const TimelineFilterSelectionState.initial()) {
    sortTimelineFilters();
  }

  final TimelineFilterCubit _timelineFilterCubit;

  /// Determines the origin of the timeline selection.
  ///
  /// Used to display the currently active filter (if any).
  final TimelineFilterType? _type;

  final UserData? _user;
  final TwitterListData? _list;

  void sortTimelineFilters() {
    final timelineFilterState = _timelineFilterCubit.state;

    TimelineFilter? selectedTimelineFilter;

    switch (_type) {
      case TimelineFilterType.home:
        selectedTimelineFilter = timelineFilterState.homeTimelineFilter;
        break;
      case TimelineFilterType.user:
        assert(_user != null);
        selectedTimelineFilter = timelineFilterState.userTimelineFilter(_user!);
        break;
      case TimelineFilterType.list:
        assert(_list != null);
        selectedTimelineFilter = timelineFilterState.listTimelineFilter(_list!);
        break;
      case null:
        selectedTimelineFilter = null;
        break;
    }

    final sortedTimelineFilters =
        timelineFilterState.timelineFilters.sorted((a, b) {
      if (a == selectedTimelineFilter) {
        return -1;
      } else if (b == selectedTimelineFilter) {
        return 1;
      } else {
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
          hasSelection: selectedTimelineFilter != null,
        ),
      );
    }
  }
}

@freezed
class TimelineFilterSelectionState with _$TimelineFilterSelectionState {
  const factory TimelineFilterSelectionState.initial() = _Initial;

  const factory TimelineFilterSelectionState.noFilters() = _NoFilters;

  const factory TimelineFilterSelectionState.data({
    required BuiltList<SortedTimelineFilter> sortedFilters,
    required bool hasSelection,
  }) = _Data;
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
