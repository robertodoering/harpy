import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';

/// Builds a message with a refresh button for a [TweetTimeline] when no tweets
/// were loaded.
class NoTimelineTweets<T extends TimelineBloc> extends StatelessWidget {
  const NoTimelineTweets(
    this.bloc, {
    @required this.onRefresh,
  });

  final TimelineBloc bloc;

  final OnTimelineAction<T> onRefresh;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'no tweets found',
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          HarpyButton.flat(
            dense: true,
            text: const Text('refresh'),
            onTap: () => onRefresh(bloc),
          ),
        ],
      ),
    );
  }
}
