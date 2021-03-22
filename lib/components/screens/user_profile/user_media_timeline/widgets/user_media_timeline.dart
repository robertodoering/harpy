import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class UserMediaTimeline extends StatelessWidget {
  const UserMediaTimeline();

  @override
  Widget build(BuildContext context) {
    final UserTimelineBloc bloc = context.watch<UserTimelineBloc>();

    return ChangeNotifierProvider<MediaTimelineModel>(
      create: (_) => MediaTimelineModel(
        initialTweets: bloc.state.timelineTweets,
      ),
      child: BlocListener<UserTimelineBloc, UserTimelineState>(
        listener: (BuildContext context, UserTimelineState state) {
          context
              .read<MediaTimelineModel>()
              .updateEntries(state.timelineTweets);
        },
        child: const ScrollToStart(
          child: MediaTimeline(),
        ),
      ),
    );
  }
}
