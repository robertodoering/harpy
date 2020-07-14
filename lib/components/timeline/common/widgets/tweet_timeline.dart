import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

class TweetTimeline<T extends TimelineBloc> extends StatefulWidget {
  @override
  _TweetTimelineState<T> createState() => _TweetTimelineState<T>();
}

class _TweetTimelineState<T extends TimelineBloc>
    extends State<TweetTimeline<T>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, TimelineState>(
      builder: (BuildContext context, TimelineState state) {
        final T bloc = BlocProvider.of<T>(context);

        return TweetList(bloc.tweets);
      },
    );
  }
}
