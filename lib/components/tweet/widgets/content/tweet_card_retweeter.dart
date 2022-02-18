import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TweetCardRetweeter extends StatelessWidget {
  const TweetCardRetweeter({
    required this.tweet,
    required this.style,
  });

  final TweetData tweet;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // TODO: on retweeter tap
      // onTap: () => context.read<TweetBloc>().onRetweeterTap(context),
      child: IntrinsicWidth(
        child: Row(
          children: [
            // TODO: avatar radius
            // SizedBox(
            //   width: TweetCardAvatar.defaultRadius(config.fontSizeDelta) * 2,
            //   child: Icon(FeatherIcons.repeat, size: 16 + style.sizeDelta),
            // ),
            horizontalSpacer,
            Flexible(
              child: Text(
                '${tweet.retweetUserName} retweeted',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2!
                    .copyWith(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.8),
                      height: 1,
                    )
                    .apply(fontSizeDelta: style.sizeDelta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
