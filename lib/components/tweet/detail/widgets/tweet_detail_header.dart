import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Builds the header for the [TweetDetailPage].
///
/// If the tweet has a parent, the parent tweet card will animate into view.
class TweetDetailHeader extends StatelessWidget {
  const TweetDetailHeader({
    required this.tweet,
    required this.parent,
  });

  /// The original tweet that is a reply to [parent].
  final LegacyTweetData tweet;

  /// The parent of [tweet] which is displayed in a [TweetCard].
  final LegacyTweetData? parent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: theme.animation.long,
        curve: Curves.easeOutCubic,
        alignment: AlignmentDirectional.topCenter,
        child: parent != null
            ? Column(
                children: [
                  Padding(
                    padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
                    child: TweetCard(tweet: parent!),
                  ),
                  VerticalSpacer.normal,
                  TweetListInfoMessage(
                    icon: const Icon(CupertinoIcons.reply),
                    text: Text('${tweet.user.name} replied'),
                  ),
                  VerticalSpacer.normal,
                ],
              )
            : VerticalSpacer.normal,
      ),
    );
  }
}
