import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Builds the header for the [TweetDetailPage].
///
/// If the tweet has a parent, the parent tweet card will animate into view.
class TweetDetailHeader extends ConsumerWidget {
  const TweetDetailHeader({
    required this.tweet,
    required this.parent,
  });

  /// The original tweet that is a reply to [parent].
  final TweetData tweet;

  /// The parent of [tweet] which is displayed in a [TweetCard].
  final TweetData? parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: kLongAnimationDuration,
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: parent != null
            ? Column(
                children: [
                  Padding(
                    padding: display.edgeInsets.copyWith(bottom: 0),
                    child: TweetCard(tweet: parent!),
                  ),
                  verticalSpacer,
                  TweetListInfoMessage(
                    icon: const Icon(CupertinoIcons.reply),
                    text: Text('${tweet.user.name} replied'),
                  ),
                  verticalSpacer,
                ],
              )
            : verticalSpacer,
      ),
    );
  }
}
