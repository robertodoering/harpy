import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/search/tweet/bloc/tweet_search_bloc.dart';
import 'package:harpy/components/search/tweet/widgets/content/tweet_search_app_bar.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds the [TweetList] for the [TweetSearchScreen].
class TweetSearchList extends StatelessWidget {
  const TweetSearchList();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final TweetSearchBloc bloc = context.watch<TweetSearchBloc>();
    final TweetSearchState state = bloc.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: TweetList(
          state is TweetSearchResult ? state.tweets : <TweetData>[],
          enableScroll: state.hasResults,
          beginSlivers: <Widget>[
            TweetSearchAppBar(text: state.searchQuery),
          ],
          endSlivers: <Widget>[
            if (state.showLoading)
              const SliverFillLoadingIndicator()
            else if (state.showNoResults)
              const SliverFillInfoMessage(
                primaryMessage: Text('no tweets found'),
                secondaryMessage: Text(
                  'only tweets of the last 7 days can be retrieved',
                ),
              )
            else if (state.showSearchError)
              SliverFillLoadingError(
                message: const Text('error searching tweets'),
                onRetry: () => bloc.add(const RetryTweetSearch()),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
