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
    final cubit = context.watch<UserTimelineCubit>();
    final model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'user timeline filter',
      showFilterButton: cubit.filter != model.value,
      onFilter: () {
        ScrollDirection.of(context)?.reset();
        cubit.applyFilter(model.value);
      },
      onClear: () {
        if (cubit.filter != TimelineFilter.empty) {
          ScrollDirection.of(context)!.reset();
          cubit.applyFilter(TimelineFilter.empty);
        }
      },
    );
  }
}
