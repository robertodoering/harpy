import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// A styled dialog used with [showDialog].
///
/// If the [actions] contain discard and confirm actions, the discard action
/// should always be on the left while the confirm action should be on the
/// right.
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
      if (text != null) ...[
        Text(text, style: textTheme.subtitle),
        SizedBox(height: paddingVertical)
      ],
    ];
  }

  Widget _buildActions() {
    if (actions.length > 1) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: actions,
        ),
      );
    } else if (actions.length == 1) {
      return actions.first;
    } else {
      return Container();
    }
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
              // less on the bottom to compensate for the button
              paddingVertical - 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ..._buildText(textTheme),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An action for a [HarpyDialog] that will pop the dialog with the [result].
///
/// The action will build a text button with [text] or an icon button with
/// [icon].
///
/// Either [text] or [icon] mustn't be `null`.
class DialogAction<T> extends StatelessWidget {
  const DialogAction({
    this.result,
    this.text,
    this.icon,
  }) : assert(text != null || icon != null);

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
    void onTap() => Navigator.of(context).pop(result);

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

/// Builds a [HarpyDialog] to inform about a feature being only available for
/// the pro version of harpy.
class ProFeatureDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: "Pro feature",
      text: "This is a pro only feature. giv me ur money pls",
      actions: [
        DialogAction(text: "Try it out"),
      ],
    );
  }
}
