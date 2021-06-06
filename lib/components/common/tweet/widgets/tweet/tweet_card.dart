import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds a [Card] with the [TweetCardContent] that animates when scrolling
/// down with a [ListCardAnimation].
class TweetCard extends StatelessWidget {
  TweetCard(
    this.tweet, {
    this.create,
    this.color,
    this.depth = 0,
    this.rememberVisibility = false,
  }) : super(key: ValueKey<int>(tweet.hashCode));

  final TweetData tweet;
  final Create<TweetBloc>? create;
  final Color? color;
  final int depth;
  final bool rememberVisibility;

  @override
  Widget build(BuildContext context) {
    Widget child = Card(
      color: color,
      child: Column(
        children: <Widget>[
          BlocProvider<TweetBloc>(
            create: create ?? (_) => TweetBloc(tweet),
            child: const TweetCardContent(),
          ),
          if (tweet.replies.isNotEmpty) TweetReplies(tweet, depth: depth),
        ],
      ),
    );

    if (rememberVisibility) {
      child = TweetRememberVisibility(
        key: Key('${tweet.hashCode}_visibility'),
        tweet: tweet,
        child: child,
      );
    }

    return VisibilityChangeDetector(
      key: Key('${tweet.hashCode}_visibility'),
      child: ListCardAnimation(
        buildVisibilityChangeDetector: false,
        child: child,
      ),
    );
  }
}
