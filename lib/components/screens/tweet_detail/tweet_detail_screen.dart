import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Shows the [tweet] with detailed information and its replies.
class TweetDetailScreen extends StatelessWidget {
  const TweetDetailScreen({
    required this.tweet,
  });

  final TweetData tweet;

  static const String route = 'tweet_detail_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RepliesBloc>(
      create: (_) => RepliesBloc(tweet),
      child: const ScrollDirectionListener(
        child: ScrollToStart(
          child: _TweetDetailScreenContent(),
        ),
      ),
    );
  }
}

class _TweetDetailScreenContent extends StatelessWidget {
  const _TweetDetailScreenContent();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bloc = context.watch<RepliesBloc>();
    final state = bloc.state;

    return HarpyScaffold(
      body: TweetList(
        state.replies,
        beginSlivers: [
          const HarpySliverAppBar(title: 'tweet', floating: true),
          const TweetDetailParentTweet(),
          const TweetDetailCard(),
          if (state.isLoading) ...const [
            InfoRowLoadingShimmer(),
            SliverToBoxAdapter(child: defaultVerticalSpacer),
            TweetListLoadingSliver(),
          ] else if (state.hasResult)
            const SliverBoxTweetListInfoRow(
              icon: Icon(CupertinoIcons.reply_all),
              text: Text('replies'),
            )
          else if (state.hasFailed)
            SliverFillLoadingError(
              message: const Text('error requesting replies'),
              onRetry: () => bloc.add(const LoadReplies()),
            )
          else if (state.hasNoResult)
            const SliverBoxInfoMessage(
              secondaryMessage: Text('no replies exist'),
            ),
        ],
        endSlivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
