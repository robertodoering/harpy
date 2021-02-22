import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/filter/widgets/timeline_filter_drawer.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:provider/provider.dart';

class HomeTimelineFilterDrawer extends StatelessWidget {
  const HomeTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    final HomeTimelineBloc bloc = context.watch<HomeTimelineBloc>();
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'home timeline filter',
      showFilterButton: bloc.state.timelineFilter != model.value,
      onFilter: () {
        ScrollDirection.of(context).reset();
        bloc.add(FilterHomeTimeline(timelineFilter: model.value));
      },
      onClear: () {
        if (bloc.state.timelineFilter != TimelineFilter.empty) {
          ScrollDirection.of(context).reset();
          bloc.add(const FilterHomeTimeline(
            timelineFilter: TimelineFilter.empty,
          ));
        }
      },
    );
  }
}
