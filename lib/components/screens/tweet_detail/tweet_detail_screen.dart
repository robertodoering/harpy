import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Shows the [tweet] with detailed information and its replies.
class TweetDetailScreen extends StatelessWidget {
  const TweetDetailScreen({
    required this.tweet,
  });

  final TweetData tweet;

  static const route = 'tweet_detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepliesCubit(tweet: tweet),
      child: const ScrollDirectionListener(
        child: ScrollToStart(
          child: _Content(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RepliesCubit>();
    final state = bloc.state;

    return HarpyScaffold(
      body: TweetList(
        state.replies.toList(),
        beginSlivers: [
          const HarpySliverAppBar(title: 'tweet', floating: true),
          const TweetDetailParentTweet(),
          const TweetDetailCard(),
          ...?state.maybeMap(
            loading: (_) => const [
              InfoRowLoadingShimmer(),
              SliverToBoxAdapter(child: verticalSpacer),
              TweetListLoadingSliver(),
            ],
            data: (_) => const [
              SliverBoxTweetListInfoRow(
                icon: Icon(CupertinoIcons.reply_all),
                text: Text('replies'),
              ),
            ],
            noData: (_) => const [
              SliverBoxInfoMessage(secondaryMessage: Text('no replies exist')),
            ],
            error: (_) => [
              SliverFillLoadingError(
                message: const Text('error requesting replies'),
                onRetry: bloc.request,
              )
            ],
            orElse: () => null,
          ),
        ],
        endSlivers: const [SliverBottomPadding()],
      ),
    );
  }
}
