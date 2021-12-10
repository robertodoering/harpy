import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds an [icon] and [text] row with padding for the icon that matches the
/// size of a [TweetCard] avatar.
///
/// This is intended to build a label above or below a [TweetCard].
class TweetListInfoRow extends StatelessWidget {
  const TweetListInfoRow({
    required this.icon,
    required this.text,
    this.padding,
  });

  final Widget icon;
  final Widget text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return FadeAnimation(
      duration: kShortAnimationDuration,
      curve: Curves.easeInOut,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: config.paddingValue * 2,
              vertical: config.smallPaddingValue,
            ),
        child: Row(
          children: [
            IconTheme(
              data: theme.iconTheme.copyWith(size: 18),
              child: SizedBox(
                width: TweetCardAvatar.defaultRadius(config.fontSizeDelta) * 2,
                child: icon,
              ),
            ),
            horizontalSpacer,
            Expanded(
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle1!,
                child: text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
