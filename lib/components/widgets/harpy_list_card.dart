import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HarpyListCard extends ConsumerWidget {
  const HarpyListCard({
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.border,
    this.color,
    this.onTap,
    this.enabled = true,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.verticalAlignment = CrossAxisAlignment.center,
    this.multilineTitle = false,
    this.multilineSubtitle = true,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final Border? border;
  final Color? color;
  final VoidCallback? onTap;
  final bool enabled;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final CrossAxisAlignment verticalAlignment;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: harpyTheme.borderRadius,
        border: border,
        color: color ?? Theme.of(context).cardTheme.color,
      ),
      child: HarpyListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        borderRadius: harpyTheme.borderRadius,
        color: color,
        onTap: onTap,
        enabled: enabled,
        contentPadding: contentPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        verticalAlignment: verticalAlignment,
        multilineTitle: multilineTitle,
        multilineSubtitle: multilineSubtitle,
      ),
    );
  }
}
