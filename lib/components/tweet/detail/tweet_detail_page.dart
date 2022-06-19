import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetDetailPage extends ConsumerWidget {
  const TweetDetailPage({
    required this.tweet,
  });

  final TweetData tweet;

  static const name = 'detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesState = ref.watch(repliesProvider(tweet));
    final repliesNotifier = ref.watch(repliesProvider(tweet).notifier);

    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: TweetList(
            repliesState.replies.toList(),
            beginSlivers: [
              const HarpySliverAppBar(title: Text('tweet')),
              TweetDetailHeader(
                tweet: tweet,
                parent: repliesState.parent,
              ),
              TweetDetailCard(tweet: tweet),
              ...?repliesState.mapOrNull(
                loading: (_) => const [
                  TweetListInfoMessageLoadingShimmer(),
                  TweetListLoadingSliver(),
                ],
                data: (_) => const [
                  SliverToBoxAdapter(
                    child: TweetListInfoMessage(
                      icon: Icon(CupertinoIcons.reply_all),
                      text: Text('replies'),
                    ),
                  ),
                ],
                noData: (_) => const [
                  SliverFillInfoMessage(
                    secondaryMessage: Text('no replies exist'),
                  ),
                ],
                error: (_) => [
                  SliverFillLoadingError(
                    message: const Text('error requesting replies'),
                    onRetry: repliesNotifier.load,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
