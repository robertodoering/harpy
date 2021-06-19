import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

class TweetCardRetweeter extends StatelessWidget {
  const TweetCardRetweeter({
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
      onTap: () => bloc.onRetweeterTap(context),
      child: IntrinsicWidth(
        child: Row(
          children: [
            SizedBox(
              width: TweetCardAvatar.defaultRadius * 2,
              child: Icon(FeatherIcons.repeat, size: 16 + fontSizeDelta),
            ),
            // defaultHorizontalSpacer, // todo
            Flexible(
              child: Text(
                '${tweet.retweetUserName} retweeted',
                style: theme.textTheme.bodyText2!
                    .copyWith(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.8),
                    )
                    .apply(fontSizeDelta: fontSizeDelta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
