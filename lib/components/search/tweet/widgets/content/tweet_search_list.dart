import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/search/tweet/widgets/content/tweet_search_app_bar.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds the [TweetList] for the [TweetSearchScreen].
class TweetSearchList extends StatelessWidget {
  const TweetSearchList();

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: false, // todo
          onLoadMore: () async {}, // todo
          child: const TweetList(
            <TweetData>[],
            enableScroll: false, // todo
            beginSlivers: <Widget>[
              TweetSearchAppBar(),
            ],
          ),
        ),
      ),
    );
  }
}
