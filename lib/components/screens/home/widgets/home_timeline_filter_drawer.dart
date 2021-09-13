import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HomeTimelineFilterDrawer extends StatelessWidget {
  const HomeTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeTimelineBloc>();
    final model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'home timeline filter',
      showFilterButton: bloc.state.timelineFilter != model.value,
      onFilter: () {
        ScrollDirection.of(context)!.reset();
        bloc.add(FilterHomeTimeline(timelineFilter: model.value));
      },
      onClear: () {
        if (bloc.state.timelineFilter != TimelineFilter.empty) {
          ScrollDirection.of(context)!.reset();
          bloc.add(
            const FilterHomeTimeline(timelineFilter: TimelineFilter.empty),
          );
        }
      },
    );
  }
}
