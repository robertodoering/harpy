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
    EdgeInsets? padding,
  }) = _HarpyTextButton;

  /// Equivalent to an [ElevatedButton].
  const factory HarpyButton.elevated({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
    EdgeInsets? padding,
  }) = _HarpyElevatedButton;

  /// A flat transparent icon button.
  const factory HarpyButton.icon({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
    VoidCallback? onLongPress,
    EdgeInsets? padding,
  }) = _HarpyIconButton;

  /// A flat button that matches a [Card].
  const factory HarpyButton.card({
    required VoidCallback? onTap,
    Widget? icon,
    Widget? label,
    VoidCallback? onLongPress,
    EdgeInsets? padding,
    Color? foregroundColor,
    Color? backgroundColor,
  }) = _HarpyCardButton;
}

class _HarpyTextButton extends HarpyButton {
  const _HarpyTextButton({
    required this.onTap,
    this.icon,
    this.label,
    this.padding,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return TextButton(
      style: theme.textButtonTheme.style?.copyWith(
        padding: MaterialStateProperty.all(padding),
      ),
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
    this.padding,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: theme.textButtonTheme.style?.copyWith(
        padding: MaterialStateProperty.all(padding),
      ),
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
    this.onLongPress,
    this.padding,
    this.foregroundColor,
    this.backgroundColor,
  });

  final Widget? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
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
      padding: MaterialStateProperty.all(padding ?? display.edgeInsets),
    );

    return ElevatedButton(
      onPressed: onTap,
      onLongPress: onLongPress,
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
    this.icon,
    this.label,
    this.padding,
    this.onLongPress,
  });

  final Widget? icon;
  final Widget? label;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

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
      onLongPress: onLongPress,
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
