import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/scroll_direction_listener.dart';
import 'package:harpy/components/common/scroll_to_start.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/core/api/tweet_data.dart';

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

class TweetList extends StatelessWidget {
  const TweetList(this.tweets);

  final List<TweetData> tweets;

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: ListView.separated(
          itemCount: tweets.length,
          itemBuilder: (BuildContext context, int index) =>
              TweetTile(tweets[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: Colors.white),
        ),
      ),
    );
  }
}

class TweetTile extends StatelessWidget {
  const TweetTile(this.tweet);

  final TweetData tweet;

  List<Widget> _buildReplies() {
    return tweet.replies.map((TweetData tweet) {
      return Column(
        children: <Widget>[
          const Text('reply'),
          TweetTile(tweet),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (tweet.isRetweet) Text('retweeted by ${tweet.retweetUserName}'),
        Text(tweet.userData.name),
        Text(tweet.createdAt.toIso8601String()),
        Text(tweet.fullText),
        if (tweet.replies.isNotEmpty) ..._buildReplies(),
      ],
    );
  }
}
