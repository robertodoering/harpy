import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/scroll_aware_floating_action_button.dart';
import 'package:harpy/components/timeline/likes_timeline/bloc/likes_timeline_bloc.dart';
import 'package:harpy/components/timeline/likes_timeline/widgets/likes_timeline.dart';
import 'package:provider/provider.dart';

class UserLikesTimeline extends StatelessWidget {
  const UserLikesTimeline();

  Widget _buildFloatingActionButton(
    BuildContext context,
    LikesTimelineBloc bloc,
  ) {
    return FloatingActionButton(
      onPressed: () async {
        ScrollDirection.of(context).reset();
        bloc.add(const RequestLikesTimeline());
      },
      child: const Icon(CupertinoIcons.refresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LikesTimelineBloc bloc = context.watch<LikesTimelineBloc>();
    final LikesTimelineState state = bloc.state;

    return ScrollAwareFloatingActionButton(
      floatingActionButton: state is LikesTimelineResult
          ? _buildFloatingActionButton(context, bloc)
          : null,
      child: const LikesTimeline(),
    );
  }
}
