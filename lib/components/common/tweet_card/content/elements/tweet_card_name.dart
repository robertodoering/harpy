import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
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

    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    final fontSizeDelta =
        app<LayoutPreferences>().fontSizeDelta + style.sizeDelta;

    return GestureDetector(
      onTap: () => context.read<TweetBloc>().onUserTap(context),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Flexible(
              child: Text(
                tweet.user.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2!
                    .copyWith(height: 1)
                    .apply(fontSizeDelta: fontSizeDelta),
              ),
            ),
            if (tweet.user.verified) ...[
              const SizedBox(width: 4),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16 + fontSizeDelta,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
