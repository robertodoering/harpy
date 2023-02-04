import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TweetCardPinned extends ConsumerWidget {
  const TweetCardPinned({
    required this.style,
  });

  final TweetCardElementStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final textStyle = theme.textTheme.bodyMedium!;

    return IntrinsicWidth(
      child: Row(
        children: [
          SizedBox(
            width: TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
            child: Icon(
              CupertinoIcons.pin_fill,
              size: textStyle.fontSize! + style.sizeDelta,
            ),
          ),
          HorizontalSpacer.normal,
          Flexible(
            child: FittedBox(
              child: Text(
                'pinned',
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
    );
  }
}
