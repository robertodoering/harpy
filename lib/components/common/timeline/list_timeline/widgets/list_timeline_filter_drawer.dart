import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class ListTimelineFilterDrawer extends StatelessWidget {
  const ListTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ListTimelineCubit>();
    final model = context.watch<TimelineFilterModel>();

    return TimelineFilterDrawer(
      title: 'list timeline filter',
      showFilterButton: cubit.filter != model.value,
      onFilter: () {
        ScrollDirection.of(context)?.reset();
        cubit.applyFilter(model.value);
      },
      onClear: () {
        if (cubit.filter != TimelineFilter.empty) {
          ScrollDirection.of(context)?.reset();
          cubit.applyFilter(TimelineFilter.empty);
        }
      },
    );
  }
}
