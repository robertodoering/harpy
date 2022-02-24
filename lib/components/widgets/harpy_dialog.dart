import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class HarpyDialog extends ConsumerWidget {
  const HarpyDialog({
    this.title,
    this.stickyContent,
    this.content,
    this.actions,
    this.clipBehavior = Clip.none,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
  });

  final Widget? title;
  final Widget? stickyContent;
  final Widget? content;
  final List<Widget>? actions;

  final Clip clipBehavior;

  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? actionsPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    Widget? titleWidget;

    if (title != null)
      titleWidget = Center(
        child: Padding(
          padding: titlePadding ?? (display.edgeInsets * 2).copyWith(bottom: 0),
          child: DefaultTextStyle(
            style: theme.textTheme.headline6!,
            textAlign: TextAlign.center,
            child: title!,
          ),
        ),
      );

    return Unfocus(
      child: Dialog(
        clipBehavior: clipBehavior,
        child: AnimatedSize(
          duration: kShortAnimationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (titleWidget != null) titleWidget,
              if (stickyContent != null) stickyContent!,
              Flexible(
                child: Padding(
                  padding: contentPadding ?? display.edgeInsets,
                  child: DefaultTextStyle(
                    style: theme.textTheme.subtitle2!,
                    child: SingleChildScrollView(child: content),
                  ),
                ),
              ),
              if (actions != null)
                HarpyDialogActionBar(
                  actions: actions!,
                  padding: actionsPadding,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HarpyDialogActionBar extends ConsumerWidget {
  const HarpyDialogActionBar({
    required this.actions,
    this.padding,
  });

  final List<Widget> actions;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: padding ?? display.edgeInsets.copyWith(top: 0),
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceAround,
        spacing: display.paddingValue,
        overflowSpacing: display.smallPaddingValue,
        overflowAlignment: OverflowBarAlignment.center,
        children: actions,
      ),
    );
  }
}
