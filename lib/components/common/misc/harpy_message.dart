import 'package:flutter/material.dart';

/// Builds a widget similar to a [SnackBar] that is intended to be shown at the
/// bottom of the screen with the [HarpyMessageHandler].
class HarpyMessage extends StatefulWidget {
  const HarpyMessage.info(this.text)
      : iconColor = Colors.blue,
        icon = Icons.info_outline;

  const HarpyMessage.warning(this.text)
      : iconColor = Colors.orange,
        icon = Icons.error_outline;

  const HarpyMessage.error(this.text)
      : iconColor = Colors.red,
        icon = Icons.error_outline;

  /// The text for this message.
  final String text;

  /// The color for the icon.
  final Color iconColor;

  /// The icon built to the left of the text.
  final IconData icon;

  @override
  _HarpyMessageState createState() => _HarpyMessageState();
}

class _HarpyMessageState extends State<HarpyMessage>
    with SingleTickerProviderStateMixin {
  Color textColor;
  Color iconColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ThemeData theme = Theme.of(context);

    final Brightness backgroundBrightness =
        ThemeData.estimateBrightnessForColor(theme.accentColor);

    final Brightness iconColorBrightness =
        ThemeData.estimateBrightnessForColor(widget.iconColor);

    // set the text color to compliment the background color
    textColor =
        backgroundBrightness == Brightness.dark ? Colors.white : Colors.black;

    // if the widget.iconColor does not compliment the background color, use the
    // same color as the text instead
    iconColor = iconColorBrightness == backgroundBrightness
        ? textColor
        : widget.iconColor;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: true,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.all(16),
          color: theme.accentColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Icon(
                  widget.icon,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.text,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
