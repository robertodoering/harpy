import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Builds an [icon] and [text] in a row with padding for the icon that matches
/// the size of a [TweetCard] avatar.
///
/// This is intended to build a message above or below a [TweetCard].
class TweetListInfoMessage extends ConsumerWidget {
  const TweetListInfoMessage({
    required this.icon,
    required this.text,
  });

  final Widget icon;
  final Widget text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return ImmediateOpacityAnimation(
      duration: theme.animation.short,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.base * 2,
          vertical: theme.spacing.small,
        ),
        child: Row(
          children: [
            IconTheme(
              data: theme.iconTheme.copyWith(size: theme.iconTheme.size! - 2),
              child: SizedBox(
                width: TweetCardAvatar.defaultRadius(display.fontSizeDelta) * 2,
                child: icon,
              ),
            ),
            HorizontalSpacer.normal,
            Expanded(
              child: DefaultTextStyle(
                style: theme.textTheme.titleMedium!,
                child: text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
