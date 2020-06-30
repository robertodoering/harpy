import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/bounce_in_animation.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/harpy_background.dart';

/// A styled dialog used with [showDialog].
///
/// If the [actions] contain discard and confirm actions, the discard action
/// should always be on the left while the confirm action should be on the
/// right.
class HarpyDialog extends StatelessWidget {
  const HarpyDialog({
    @required this.actions,
    this.title,
    this.text,
    this.body,
    this.backgroundColors,
    this.scrollPhysics,
  });

  final String title;
  final List<DialogAction<dynamic>> actions;

  /// The text is build below the [title] if not `null`.
  final String text;

  /// The body is build below the [text] if not `null`.
  final Widget body;

  /// The colors used by the [HarpyBackground].
  ///
  /// Uses the theme colors when `null`.
  final List<Color> backgroundColors;

  /// The scroll physics of the dialog (title, text + body).
  final ScrollPhysics scrollPhysics;

  List<Widget> _buildContent(TextTheme textTheme) {
    return <Widget>[
      if (title != null) ...<Widget>[
        Text(title, style: textTheme.headline6, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      if (text != null) ...<Widget>[
        Text(text, style: textTheme.subtitle2, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      if (body != null) ...<Widget>[
        body,
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 12),
    ];
  }

  Widget _buildActions() {
    if (actions.length > 1) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BounceInAnimation(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: HarpyBackground(
          colors: backgroundColors,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            // less on the bottom to compensate for the button padding
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    physics: scrollPhysics,
                    children: _buildContent(textTheme),
                  ),
                ),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An action for a [HarpyDialog].
///
/// If [result] is not `null` the action will pop the dialog with the [result].
/// If [onTap] is not `null` the action will execute the callback.
///
/// The action will build a text button with [text] or an icon button with
/// [icon].
///
/// Either [text] or [icon] must not be `null`.
class DialogAction<T> extends StatelessWidget {
  const DialogAction({
    this.result,
    this.onTap,
    this.text,
    this.icon,
  })  : assert(result != null || onTap != null),
        assert(text != null || icon != null);

  final T result;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  static DialogAction<bool> discard = const DialogAction<bool>(
    result: false,
    icon: Icons.close,
  );

  static DialogAction<bool> confirm = const DialogAction<bool>(
    result: true,
    icon: Icons.check,
  );

  @override
  Widget build(BuildContext context) {
    final Function callback = onTap ?? () => Navigator.of(context).pop(result);

    if (text != null) {
      return HarpyButton.flat(
        text: text,
        onTap: callback,
        dense: true,
      );
    } else if (icon != null) {
      return HarpyButton.flat(
        icon: icon,
        onTap: callback,
        dense: true,
      );
    } else {
      return Container();
    }
  }
}
