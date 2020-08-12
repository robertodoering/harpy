import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/bounce_in_animation.dart';
import 'package:harpy/components/common/animations/explicit/slide_in_animation.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';

/// Determines the animation that is used when building a [HarpyDialog].
enum DialogAnimationType {
  // the default material animation
  material,

  // a playful bounce in animation
  bounce,

  // a subtle slide animation
  slide,
}

/// A styled dialog used with [showDialog].
///
/// If the [actions] contain discard and confirm actions, the discard action
/// should always be on the left while the confirm action should be on the
/// right.
class HarpyDialog extends StatelessWidget {
  const HarpyDialog({
    this.title,
    this.actions,
    this.text,
    this.body,
    this.backgroundColors,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.animationType = DialogAnimationType.bounce,
  });

  final String title;

  /// The actions that appear at the bottom of the dialog.
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

  /// Determines the animation used for building the harpy dialog.
  final DialogAnimationType animationType;

  bool get _hasActions => actions?.isNotEmpty == true;

  Widget _buildActions() {
    if (actions.length > 1) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: actions,
        ),
      );
    } else {
      return actions.first;
    }
  }

  Widget _buildAnimation({@required Widget child}) {
    switch (animationType) {
      case DialogAnimationType.slide:
        return SlideInAnimation(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuad,
          offset: const Offset(0, 40),
          child: child,
        );
      case DialogAnimationType.bounce:
        return BounceInAnimation(child: child);
        break;
      case DialogAnimationType.material:
      default:
        return child;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _buildAnimation(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: HarpyBackground(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            // less on the bottom to compensate for the button padding
            padding: const EdgeInsets.only(
              left: 16,
              top: 32,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) ...<Widget>[
                  Text(
                    title,
                    style: textTheme.headline6.copyWith(height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                Flexible(
                  child: ListView(
                    physics: scrollPhysics,
                    shrinkWrap: true,
                    children: <Widget>[
                      if (text != null) ...<Widget>[
                        Text(
                          text,
                          style: textTheme.subtitle2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (body != null) ...<Widget>[
                        body,
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
                if (_hasActions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _buildActions(),
                  ),
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
