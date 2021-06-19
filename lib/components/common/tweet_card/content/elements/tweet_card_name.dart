import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

class TweetCardName extends StatelessWidget {
  const TweetCardName({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return GestureDetector(
      onTap: () => bloc.onUserTap(context),
      child: IntrinsicWidth(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                tweet.user.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2!.apply(
                  fontSizeDelta: fontSizeDelta + style.sizeDelta,
                ),
              ),
            ),
            if (tweet.user.verified) ...[
              const SizedBox(width: 4),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16 + fontSizeDelta + style.sizeDelta,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
