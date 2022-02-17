import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

abstract class HarpyButton extends ConsumerWidget {
  const HarpyButton();

  /// Equivalent to a [TextButton].
  const factory HarpyButton.text({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
  }) = _HarpyTextButton;

  /// Equivalant to an [ElevatedButton].
  const factory HarpyButton.elevated({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
  }) = _HarpyElevatedButton;

  /// A flat transparent icon button.
  const factory HarpyButton.icon({
    required VoidCallback? onTap,
    required Widget icon,
    EdgeInsets? padding,
  }) = _HarpyIconButton;

  /// A flat button that matches a [Card].
  const factory HarpyButton.card({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
    Color? foregroundColor,
    Color? backgroundColor,
  }) = _HarpyCardButton;
}

class _HarpyTextButton extends HarpyButton {
  const _HarpyTextButton({
    required this.onTap,
    this.icon,
    this.label,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && label != null) smallHorizontalSpacer,
          if (label != null) label!,
        ],
      ),
    );
  }
}

class _HarpyElevatedButton extends HarpyButton {
  const _HarpyElevatedButton({
    required this.onTap,
    this.icon,
    this.label,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && label != null) smallHorizontalSpacer,
          if (label != null) label!,
        ],
      ),
    );
  }
}

class _HarpyCardButton extends HarpyButton {
  const _HarpyCardButton({
    required this.onTap,
    this.icon,
    this.label,
    this.foregroundColor,
    this.backgroundColor,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final background = backgroundColor ?? theme.cardTheme.color!;
    final foreground = foregroundColor ?? theme.colorScheme.onBackground;

    final style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? background.withOpacity(0)
            : background,
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? foreground.withOpacity(.5)
            : foreground,
      ),
      overlayColor: MaterialStateProperty.all(theme.highlightColor),
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(display.edgeInsets),
    );

    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && label != null) smallHorizontalSpacer,
          if (label != null) label!,
        ],
      ),
    );
  }
}

class _HarpyIconButton extends HarpyButton {
  const _HarpyIconButton({
    required this.onTap,
    required this.icon,
    this.padding,
  });

  final Widget icon;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? theme.colorScheme.onBackground.withOpacity(.5)
            : theme.colorScheme.onBackground,
      ),
      overlayColor: MaterialStateProperty.all(theme.highlightColor),
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(padding ?? display.edgeInsets),
    );

    return TextButton(
      onPressed: onTap,
      style: style,
      child: icon,
    );
  }
}
