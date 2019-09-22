import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/core/misc/url_launcher.dart';

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
  final List<DialogAction> actions;

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
      if (title != null) ...[
        Text(title, style: textTheme.title, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      if (text != null) ...[
        Text(text, style: textTheme.subtitle, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      if (body != null) ...[
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
    final textTheme = Theme.of(context).textTheme;

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

/// Builds a [HarpyDialog] to inform about a feature being only available for
/// the pro version of harpy.
class ProFeatureDialog extends StatefulWidget {
  const ProFeatureDialog({
    @required this.name,
  });

  /// The name of the feature.
  final String name;

  @override
  _ProFeatureDialogState createState() => _ProFeatureDialogState();
}

class _ProFeatureDialogState extends State<ProFeatureDialog> {
  GestureRecognizer _recognizer;

  @override
  void initState() {
    _recognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(
          "https://play.google.com/store/search?q=harpy%20pro"); // todo: harpy pro playstore url

    super.initState();
  }

  @override
  void dispose() {
    _recognizer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.subtitle;

    final linkStyle = style.copyWith(
      color: theme.accentColor,
      fontWeight: FontWeight.bold,
    );

    return HarpyDialog(
      title: "Pro feature",
      body: Column(
        children: <Widget>[
          const FlareIcon.shiningStar(size: 64),
          const SizedBox(height: 12),
          Text(
            "${widget.name} is only available in the pro version for Harpy.",
            style: style,
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(
                  text: "Buy Harpy Pro in the ",
                ),
                TextSpan(
                  text: "Play Store",
                  style: linkStyle,
                  recognizer: _recognizer,
                ),
              ],
            ),
            style: style,
          ),
        ],
      ),
      actions: [
        const DialogAction<bool>(
          result: true,
          text: "Try it out",
        ),
      ],
    );
  }
}
