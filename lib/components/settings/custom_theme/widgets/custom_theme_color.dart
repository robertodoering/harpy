import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
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
    this.contentPadding,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool allowTransparency;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;

  Future<void> _changeColor(BuildContext context) async {
    removeFocus(context);

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
        textTheme: theme.textTheme
            .apply(
              bodyColor: textColor,
              displayColor: textColor,
            )
            .copyWith(
              // override the body text which is used as the sub title
              bodyText2: theme.textTheme.subtitle2!.copyWith(fontSize: 14),
            ),
        iconTheme: theme.iconTheme.copyWith(color: textColor),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: kDefaultBorderRadius,
          border: Border.all(
            color: theme.dividerColor,
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: color,
          child: ListTile(
            contentPadding: contentPadding,
            shape: kDefaultShapeBorder,
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            onTap: () => _changeColor(context),
          ),
        ),
      ),
    );
  }
}
