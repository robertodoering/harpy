import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/widgets/search_text_field.dart';

/// Builds a sliver app bar for the [TweetSearchScreen] with a [SearchTextField]
/// in the title.
class TweetSearchAppBar extends StatelessWidget {
  const TweetSearchAppBar();

  @override
  Widget build(BuildContext context) {
    return HarpySliverAppBar(
      titleWidget: Container(
        child: SearchTextField(
          hintText: 'search tweets',
          onSubmitted: (String text) {}, // todo
          onClear: () {}, // todo
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
