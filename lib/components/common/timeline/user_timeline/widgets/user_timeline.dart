import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserTimelineCubit>();

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: const Timeline(
        listKey: PageStorageKey('user_timeline'),
      ),
    );
  }
}
