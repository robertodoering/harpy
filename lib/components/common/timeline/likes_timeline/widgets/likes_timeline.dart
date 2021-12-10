import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class LikesTimeline extends StatelessWidget {
  const LikesTimeline();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LikesTimelineCubit>();

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: const Timeline(
        listKey: PageStorageKey('likes_timeline'),
      ),
    );
  }
}
