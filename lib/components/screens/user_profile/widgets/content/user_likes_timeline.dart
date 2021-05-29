import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class UserLikesTimeline extends StatelessWidget {
  const UserLikesTimeline();

  Widget _buildFloatingActionButton(
    BuildContext context,
    LikesTimelineBloc bloc,
  ) {
    return FloatingActionButton(
      onPressed: () async {
        ScrollDirection.of(context)!.reset();
        bloc.add(const RequestLikesTimeline());
      },
      child: const Icon(CupertinoIcons.refresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LikesTimelineBloc>();
    final state = bloc.state;

    return ScrollAwareFloatingActionButton(
      floatingActionButton: state is LikesTimelineResult
          ? _buildFloatingActionButton(context, bloc)
          : null,
      child: const LikesTimeline(),
    );
  }
}
