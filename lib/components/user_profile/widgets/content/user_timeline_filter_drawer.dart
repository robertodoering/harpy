import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/filter/widgets/timeline_filter_drawer.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:provider/provider.dart';

class UserTimelineFilterDrawer extends StatelessWidget {
  const UserTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    final UserTimelineBloc bloc = context.watch<UserTimelineBloc>();
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'user timeline filter',
      showFilterButton: bloc.state.timelineFilter != model.value,
      onFilter: () {
        ScrollDirection.of(context).reset();
        bloc.add(FilterUserTimeline(timelineFilter: model.value));
      },
      onClear: () {
        if (bloc.state.timelineFilter != TimelineFilter.empty) {
          ScrollDirection.of(context).reset();
          bloc.add(const FilterUserTimeline(
            timelineFilter: TimelineFilter.empty,
          ));
        }
      },
    );
  }
}
