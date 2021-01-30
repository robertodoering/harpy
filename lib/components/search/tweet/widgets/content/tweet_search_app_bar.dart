import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/tweet/bloc/tweet_search_bloc.dart';
import 'package:harpy/components/search/widgets/search_text_field.dart';

/// Builds a sliver app bar for the [TweetSearchScreen] with a [SearchTextField]
/// in the title.
class TweetSearchAppBar extends StatelessWidget {
  const TweetSearchAppBar({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final TweetSearchBloc bloc = context.watch<TweetSearchBloc>();

    return HarpySliverAppBar(
      titleWidget: Container(
        child: SearchTextField(
          text: text,
          hintText: 'search tweets',
          onSubmitted: (String text) => bloc.add(SearchTweets(query: text)),
          onClear: () => bloc.add(const ClearSearchResult()),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: Scaffold.of(context).openEndDrawer,
        ),
      ],
      floating: true,
    );
  }
}
