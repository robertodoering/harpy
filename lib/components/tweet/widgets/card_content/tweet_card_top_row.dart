import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds the top row for the [TweetCardContent].
///
/// The top row consist of the following tweet card elements:
/// - [TweetCardElement.retweeter]
/// - [TweetCardElement.avatar]
/// - [TweetCardElement.name]
/// - [TweetCardElement.handle]
/// - [TweetCardElement.actionsButton]
class TweetCardTopRow extends ConsumerWidget {
  const TweetCardTopRow({
    required this.tweet,
    required this.delegates,
    required this.outerPadding,
    required this.innerPadding,
    required this.config,
  });

  final LegacyTweetData tweet;
  final TweetDelegates delegates;

  final double outerPadding;
  final double innerPadding;

  final TweetCardConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = TweetCardElement.pinned.shouldBuild(tweet, config);
    final retweeter = TweetCardElement.retweeter.shouldBuild(tweet, config);
    final avatar = TweetCardElement.avatar.shouldBuild(tweet, config);
    final name = TweetCardElement.name.shouldBuild(tweet, config);
    final handle = TweetCardElement.handle.shouldBuild(tweet, config);
    final actionsButton = TweetCardElement.actionsButton.shouldBuild(
      tweet,
      config,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: outerPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: outerPadding),
              if (pinned) ...[
                TweetCardPinned(style: TweetCardElement.pinned.style(config)),
                if (retweeter || (avatar && name && handle))
                  SizedBox(height: innerPadding),
              ],
              if (retweeter) ...[
                TweetCardRetweeter(
                  tweet: tweet,
                  onRetweeterTap: delegates.onShowRetweeter,
                  style: TweetCardElement.retweeter.style(config),
                ),
                if (avatar && name && handle) SizedBox(height: innerPadding),
              ],
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => delegates.onShowUser?.call(ref),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (avatar) ...[
                      TweetCardAvatar(
                        tweet: tweet,
                        onUserTap: delegates.onShowUser,
                        style: TweetCardElement.avatar.style(config),
                      ),
                      SizedBox(width: outerPadding),
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name && tweet.user.name.isNotEmpty)
                            TweetCardName(
                              tweet: tweet,
                              onUserTap: delegates.onShowUser,
                              style: TweetCardElement.name.style(config),
                            ),
                          if (name && handle)
                            SizedBox(height: innerPadding / 2),
                          if (handle)
                            TweetCardHandle(
                              tweet: tweet,
                              onUserTap: delegates.onShowUser,
                              style: TweetCardElement.handle.style(config),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: innerPadding),
            ],
          ),
        ),
        if (actionsButton)
          TweetCardActionsButton(
            tweet: tweet,
            delegates: delegates,
            padding: EdgeInsets.all(outerPadding),
            style: TweetCardElement.actionsButton.style(config),
          ),
      ],
    );
  }
}
