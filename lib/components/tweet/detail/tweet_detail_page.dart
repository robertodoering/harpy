import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/tweet/detail/provider/tweet_detail_provider.dart';
import 'package:rby/rby.dart';

class TweetDetailPage extends ConsumerStatefulWidget {
  const TweetDetailPage({
    required this.id,
    this.tweet,
  });

  final String id;
  final LegacyTweetData? tweet;

  static const name = 'detail';

  @override
  ConsumerState<TweetDetailPage> createState() {
    return _TweetDetailPageState();
  }
}

class _TweetDetailPageState extends ConsumerState<TweetDetailPage> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          ref.read(tweetDetailProvider(widget.id).notifier).load(widget.tweet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tweetDetailState = ref.watch(tweetDetailProvider(widget.id));

    return HarpyScaffold(
      child: widget.tweet != null
          ? _TweetDetailContent(tweet: widget.tweet!)
          : RbyAnimatedSwitcher(
              child: tweetDetailState.when(
                data: (tweet) => _TweetDetailContent(tweet: tweet),
                loading: _TweetDetailLoading.new,
                error: (_, __) => const _TweetDetailError(),
              ),
            ),
    );
  }
}

class _TweetDetailContent extends ConsumerWidget {
  const _TweetDetailContent({
    required this.tweet,
  });

  final LegacyTweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesState = ref.watch(repliesProvider(tweet));
    final repliesNotifier = ref.watch(repliesProvider(tweet).notifier);

    return ScrollDirectionListener(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TweetDetailLoading extends StatelessWidget {
  const _TweetDetailLoading();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        HarpySliverAppBar(title: Text('tweet')),
        SliverFillLoadingIndicator(),
      ],
    );
  }
}

class _TweetDetailError extends StatelessWidget {
  const _TweetDetailError();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        HarpySliverAppBar(title: Text('tweet')),
        SliverFillLoadingError(message: Text('error loading tweet')),
      ],
    );
  }
}
