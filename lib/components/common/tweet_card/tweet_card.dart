import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds a card for a tweet with its [TweetBloc].
///
/// Uses a [ListCardAnimation] to animate building the card.
class TweetCard extends StatelessWidget {
  const TweetCard(
    this.tweet, {
    this.color,
  });

  final TweetData tweet;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VisibilityChangeDetector(
      key: Key('${tweet.hashCode}_visibility'),
      child: ListCardAnimation(
        buildVisibilityChangeDetector: false,
        child: BlocProvider<TweetBloc>(
          create: (_) => TweetBloc(tweet),
          child: TweetCardBase(color: color),
        ),
      ),
    );
  }
}

/// Builds the base for the [TweetCard].
///
/// The [kDefaultTweetCardConfig] is used to build the [TweetCardContent].
class TweetCardBase extends StatelessWidget {
  const TweetCardBase({
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: !tweet.currentReplyParent(context)
          ? context.read<TweetBloc>().onTweetTap
          : null,
      child: TweetCardContent(
        outerPadding: config.paddingValue,
        innerPadding: config.smallPaddingValue,
        config: kDefaultTweetCardConfig,
      ),
    );

    return Card(
      color: color,
      child: tweet.replies.isEmpty
          ? child
          : Column(
              children: [
                child,
                TweetCardReplies(color: color),
              ],
            ),
    );
  }
}
