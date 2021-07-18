import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HarpyListTile extends StatelessWidget {
  const HarpyListTile({
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.borderRadius,
    this.color,
    this.onTap,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.multilineTitle = false,
    this.multilineSubtitle = true,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigBloc>().state;

    final textStyle = theme.textTheme.subtitle2!;

    return Material(
      color: color,
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Row(
          children: [
            if (leading != null)
              Padding(
                padding: leadingPadding ??
                    EdgeInsets.all(config.paddingValue).copyWith(
                      left: config.paddingValue * 2,
                    ),
                child: leading,
              ),
            if (title != null || subtitle != null)
              Expanded(
                child: Padding(
                  padding: contentPadding ??
                      EdgeInsets.only(
                        top: config.paddingValue,
                        bottom: config.paddingValue,
                        left: leading == null
                            ? config.paddingValue * 2
                            : config.paddingValue,
                        right: trailing == null
                            ? config.paddingValue * 2
                            : config.paddingValue,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          maxLines: multilineTitle ? null : 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.copyWith(
                            height: multilineTitle ? null : 1,
                          ),
                          child: title!,
                        ),
                      if (title != null && subtitle != null)
                        defaultSmallVerticalSpacer,
                      if (subtitle != null)
                        DefaultTextStyle(
                          maxLines: multilineTitle ? null : 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle
                              .copyWith(
                                height: multilineTitle ? null : 1,
                              )
                              .apply(
                                fontSizeDelta: -2,
                                color: textStyle.color!.withOpacity(.8),
                              ),
                          child: subtitle!,
                        ),
                    ],
                  ),
                ),
              )
            else
              const Spacer(),
            if (trailing != null)
              Padding(
                padding: trailingPadding ??
                    EdgeInsets.all(config.paddingValue).copyWith(
                      right: config.paddingValue * 2,
                    ),
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
