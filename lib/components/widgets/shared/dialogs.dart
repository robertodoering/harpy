import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

class HarpyDialog extends StatelessWidget {
  const HarpyDialog({
    @required this.title,
    this.text,
    @required this.actions,
  });

  final String title;
  final String text;
  final List<DialogAction> actions;

  final double paddingVertical = 24;
  final double paddingHorizontal = 12;

  List<Widget> _buildText(TextTheme textTheme) {
    return [
      Text(title, style: textTheme.title),
      SizedBox(height: paddingHorizontal),
      if (text != null) Text(text, style: textTheme.subtitle),
      if (text != null) SizedBox(height: paddingVertical),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final harpyTheme = ThemeSettingsModel.of(context).harpyTheme;
    final textTheme = harpyTheme.theme.textTheme;

    return BounceInAnimation(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: HarpyBackground(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              paddingHorizontal,
              paddingVertical,
              paddingHorizontal,
              paddingVertical -
                  12, // less on the bottom to compensate for the button
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ..._buildText(textTheme),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: actions,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogAction<T> extends StatelessWidget {
  const DialogAction({
    this.result,
    this.text,
    this.icon,
  });

  final T result;
  final String text;
  final IconData icon;

  static DialogAction<bool> discard = const DialogAction(
    result: false,
    icon: Icons.close,
  );
  static DialogAction<bool> confirm = const DialogAction(
    result: true,
    icon: Icons.check,
  );

  @override
  Widget build(BuildContext context) {
    VoidCallback onTap = () => Navigator.of(context).pop(result);

    if (text != null) {
      return NewFlatHarpyButton(
        text: text,
        onTap: onTap,
      );
    }

    if (icon != null) {
      return IconHarpyButton(
        iconData: icon,
        onTap: onTap,
      );
    }

    return Container();
  }
}
