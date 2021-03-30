import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

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
    final TweetSearchFilterModel model =
        context.watch<TweetSearchFilterModel>();

    return HarpySliverAppBar(
      titleWidget: Container(
        child: SearchTextField(
          text: text,
          hintText: 'search tweets',
          onSubmitted: (String text) =>
              bloc.add(SearchTweets(customQuery: text)),
          onClear: () {
            bloc.add(const ClearSearchResult());
            model.clear();
          },
        ),
      ),
      actions: <Widget>[
        HarpyButton.flat(
          padding: const EdgeInsets.all(16),
          icon: const Icon(Icons.filter_alt_outlined),
          onTap: () {
            removeFocus(context);

            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      floating: true,
    );
  }
}
