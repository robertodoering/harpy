import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class CustomThemeColor extends ConsumerWidget {
  const CustomThemeColor({
    required this.color,
    required this.onColorChanged,
    this.enableAlpha = false,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets? padding;

  Future<void> _changeColor(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final newColor = await showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        color: color,
        enableAlpha: enableAlpha,
        onColorChanged: onColorChanged,
      ),
    );

    if (newColor != null) onColorChanged(newColor);
  }

  Color _onBackground(Color background) {
    final interpolatedColor = Color.lerp(background, color, color.opacity)!;

    return ThemeData.estimateBrightnessForColor(interpolatedColor) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          onBackground: _onBackground(harpyTheme.colors.averageBackgroundColor),
        ),
      ),
      child: RbyListCard(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        leadingPadding: padding,
        trailingPadding: padding,
        onTap: () => _changeColor(context),
        border: Border.all(color: theme.dividerColor),
        color: color,
      ),
    );
  }
}
