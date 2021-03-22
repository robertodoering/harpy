import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

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
          padding: EdgeInsets.symmetric(
            horizontal: defaultPaddingValue * 2,
            vertical: defaultPaddingValue / 2,
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: TweetAuthorRow.defaultAvatarRadius * 2,
                child: Icon(CupertinoIcons.reply_all, size: 18),
              ),
              defaultHorizontalSpacer,
              Expanded(
                child: Text(
                  'replies',
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
