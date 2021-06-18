import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds a card for a tweet in the home timeline.
///
/// Uses [TweetRememberVisibility] to save the last visible tweet id.
class HomeTimelineTweetCard extends StatelessWidget {
  const HomeTimelineTweetCard(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    return VisibilityChangeDetector(
      key: Key('${tweet.hashCode}_visibility'),
      child: ListCardAnimation(
        buildVisibilityChangeDetector: false,
        child: TweetRememberVisibility(
          tweet: tweet,
          child: BlocProvider<TweetBloc>(
            create: (_) => TweetBloc(tweet),
            child: const TweetCardBase(),
          ),
        ),
      ),
    );
  }
}
