import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';

/// Builds a sliver indicating that no replies were found for the
/// [RepliesScreen].
class NoRepliesFound extends StatelessWidget {
  const NoRepliesFound();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: ListCardAnimation(
        key: const Key('replies'),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'no replies found',
                style: theme.textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Text(
                'Only replies of the last 7 days can be retrieved.',
                style: theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
