import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';

/// Builds a sliver for the title of the replies tweet list in the
/// [RepliesScreen].
class RepliesListTitle extends StatelessWidget {
  const RepliesListTitle();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: ListCardAnimation(
        key: const Key('replies'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 40,
                child: Icon(Icons.reply, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Replies',
                  style: theme.textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
