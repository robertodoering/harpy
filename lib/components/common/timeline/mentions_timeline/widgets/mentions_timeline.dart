import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class MentionsTimeline extends StatelessWidget {
  const MentionsTimeline();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final MentionsTimelineBloc bloc = context.watch<MentionsTimelineBloc>();
    final MentionsTimelineState state = bloc.state;

    return ScrollToStart(
      child: TweetList(
        state.timelineTweets,
        key: const PageStorageKey<String>('mentions_timeline'),
        endSlivers: <Widget>[
          if (state.showLoading)
            const SliverFillLoadingIndicator()
          else if (state.showNoMentionsFound)
            const SliverFillLoadingError(
              message: Text('no mentions found'),
            )
          else if (state.showMentionsError)
            SliverFillLoadingError(
              message: const Text('error loading mentions'),
              onRetry: () => bloc.add(const RequestMentionsTimeline(
                updateViewedMention: true,
              )),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
