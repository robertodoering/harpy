import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TweetCardRetweeter extends ConsumerWidget {
  const TweetCardRetweeter({
    required this.tweet,
    required this.onRetweeterTap,
    required this.style,
  });

  final LegacyTweetData tweet;
  final TweetActionCallback? onRetweeterTap;
  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final textStyle = theme.textTheme.bodyMedium!;

    return GestureDetector(
      onTap: () => onRetweeterTap?.call(ref),
      child: IntrinsicWidth(
        child: Row(
          children: [
            SizedBox(
              width: TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
              child: Icon(
                FeatherIcons.repeat,
                size: textStyle.fontSize! + style.sizeDelta,
              ),
            ),
            HorizontalSpacer.normal,
            Flexible(
              child: FittedBox(
                child: Text(
                  '${tweet.retweeter!.name} retweeted',
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  style: textStyle
                      .copyWith(
                        color: textStyle.color?.withOpacity(.8),
                        height: 1,
                      )
                      .apply(fontSizeDelta: style.sizeDelta),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
