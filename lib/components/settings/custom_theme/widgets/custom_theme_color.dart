import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class CustomThemeColor extends StatelessWidget {
  const CustomThemeColor({
    required this.color,
    required this.onColorChanged,
    this.allowTransparency = false,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool allowTransparency;
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
        allowTransparency: allowTransparency,
        onColorChanged: onColorChanged,
      ),
    );

    if (newColor != null) {
      onColorChanged(newColor);
    }
  }

  Color _textColor(CustomThemeCubit cubit) {
    final interpolatedColor = Color.lerp(
      cubit.harpyTheme.averageBackgroundColor,
      color,
      color.opacity,
    )!;

    return ThemeData.estimateBrightnessForColor(interpolatedColor) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<CustomThemeCubit>();

    final textColor = _textColor(cubit);

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        iconTheme: theme.iconTheme.copyWith(color: textColor),
      ),
      child: HarpyListCard(
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
