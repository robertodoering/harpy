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
    this.enabled = true,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.verticalAlignment,
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
  final bool enabled;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final CrossAxisAlignment? verticalAlignment;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final textStyle = theme.textTheme.subtitle2!;
    final fgColor = textStyle.color!;

    return Material(
      color: color,
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: borderRadius,
        child: IconTheme(
          data: theme.iconTheme.copyWith(
            color: enabled ? fgColor : fgColor.withOpacity(.4),
          ),
          child: Row(
            crossAxisAlignment: verticalAlignment ??
                (title != null && subtitle != null
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center),
            children: [
              if (leading != null)
                Padding(
                  padding: leadingPadding ?? config.edgeInsets,
                  child: leading,
                ),
              if (title != null || subtitle != null)
                Expanded(
                  child: Padding(
                    padding: contentPadding ?? config.edgeInsets,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          DefaultTextStyle(
                            maxLines: multilineTitle ? 3 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle.copyWith(
                              height: multilineTitle ? null : 1,
                              color: textStyle.color!.withOpacity(
                                enabled ? textStyle.color!.opacity : .4,
                              ),
                            ),
                            child: title!,
                          ),
                        if (title != null && subtitle != null)
                          smallVerticalSpacer,
                        if (subtitle != null)
                          DefaultTextStyle(
                            maxLines: multilineSubtitle ? null : 1,
                            overflow: multilineSubtitle
                                ? TextOverflow.clip
                                : TextOverflow.ellipsis,
                            style: textStyle
                                .copyWith(
                                  height: multilineSubtitle ? null : 1,
                                  color: textStyle.color!.withOpacity(
                                    enabled ? .8 : .3,
                                  ),
                                )
                                .apply(fontSizeDelta: -2),
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
                  padding: trailingPadding ?? config.edgeInsets,
                  child: trailing,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
