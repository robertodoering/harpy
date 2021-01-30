import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/search/tweet/bloc/tweet_search_bloc.dart';
import 'package:harpy/components/search/tweet/widgets/content/tweet_search_app_bar.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds the [TweetList] for the [TweetSearchScreen].
class TweetSearchList extends StatelessWidget {
  const TweetSearchList();

  @override
  Widget build(BuildContext context) {
    final TweetSearchBloc bloc = context.watch<TweetSearchBloc>();
    final TweetSearchState state = bloc.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: TweetList(
          state is TweetSearchResult ? state.tweets : <TweetData>[],
          enableScroll: state is TweetSearchResult,
          beginSlivers: <Widget>[
            TweetSearchAppBar(
              text: state is TweetSearchResult ? state.searchQuery : null,
            ),
          ],
        ),
      ),
    );
  }
}
