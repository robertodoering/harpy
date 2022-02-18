import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardName extends StatelessWidget {
  const TweetCardName({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // TODO: on user tap
      // onTap: () => context.read<TweetBloc>().onUserTap(context),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Flexible(
              child: Text(
                tweet.user.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2!
                    .copyWith(height: 1)
                    .apply(fontSizeDelta: style.sizeDelta),
              ),
            ),
            if (tweet.user.verified) ...[
              const SizedBox(width: 4),
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 16 + style.sizeDelta,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
