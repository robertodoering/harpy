import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

// TODO: remove when improving filter
// https://github.com/robertodoering/harpy/issues/341

class UserTimelineFilterDrawer extends StatelessWidget {
  const UserTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserTimelineBloc>();
    final model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'user timeline filter',
      showFilterButton: bloc.state.timelineFilter != model.value,
      onFilter: () {
        ScrollDirection.of(context)!.reset();
        bloc.add(FilterUserTimeline(timelineFilter: model.value));
      },
      onClear: () {
        if (bloc.state.timelineFilter != TimelineFilter.empty) {
          ScrollDirection.of(context)!.reset();
          bloc.add(
            const FilterUserTimeline(timelineFilter: TimelineFilter.empty),
          );
        }
      },
    );
  }
}
