import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class HarpyCard extends StatelessWidget {
  const HarpyCard({
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.border,
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

  final Border? border;
  final Color? color;
  final VoidCallback? onTap;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        border: border,
        color: color,
      ),
      child: HarpyListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        borderRadius: kDefaultBorderRadius,
        color: color,
        onTap: onTap,
        contentPadding: contentPadding ?? config.edgeInsets,
        leadingPadding: leadingPadding ?? config.edgeInsets,
        trailingPadding: trailingPadding ?? config.edgeInsets,
        multilineTitle: multilineTitle,
        multilineSubtitle: multilineSubtitle,
      ),
    );
  }
}
