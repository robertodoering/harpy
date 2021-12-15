import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a sliver app bar for the [TweetSearchScreen] with a [SearchTextField]
/// in the title.
class TweetSearchAppBar extends StatelessWidget {
  const TweetSearchAppBar({
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TweetSearchCubit>();
    final model = context.watch<TweetSearchFilterModel>();

    return HarpySliverAppBar(
      titleWidget: SearchTextField(
        text: text,
        hintText: 'search tweets',
        onSubmitted: (text) => cubit.search(customQuery: text),
        onClear: () {
          cubit.clear();
          model.clear();
        },
      ),
      actions: [
        HarpyButton.flat(
          padding: const EdgeInsets.all(16),
          icon: const Icon(Icons.filter_alt_outlined),
          onTap: () {
            FocusScope.of(context).unfocus();
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      floating: true,
    );
  }
}
