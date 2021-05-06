import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A dialog used to inform about a feature being only available for the pro
/// version of harpy.
class ProDialog extends StatefulWidget {
  const ProDialog({
    this.feature,
  });

  /// The name of the pro only feature.
  final String? feature;

  @override
  _ProDialogState createState() => _ProDialogState();
}

class _ProDialogState extends State<ProDialog> {
  GestureRecognizer? _recognizer;

  @override
  void initState() {
    super.initState();

    // todo: link to harpy pro
    // todo: add harpy pro analytics
    _recognizer = TapGestureRecognizer()
      ..onTap = () => app<MessageService>().show('coming soon!');
  }

  @override
  void dispose() {
    _recognizer!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.subtitle2!;
    final linkStyle = style.copyWith(
      color: theme.accentColor,
      fontWeight: FontWeight.bold,
    );

    return HarpyDialog(
      title: const Text('harpy pro'),
      content: Column(
        children: <Widget>[
          const FlareIcon.shiningStar(size: 64),
          const SizedBox(height: 16),
          if (widget.feature != null) ...<Widget>[
            Text(
              '${widget.feature} is only available in the '
              'pro version for harpy',
              style: style,
            ),
            const SizedBox(height: 16),
          ],
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                const TextSpan(text: 'buy harpy pro in the '),
                TextSpan(
                  text: 'play store',
                  style: linkStyle,
                  recognizer: _recognizer,
                ),
              ],
              style: style,
            ),
          ),
        ],
      ),
      actions: const <DialogAction<dynamic>>[
        DialogAction<bool>(
          result: true,
          text: 'try it out',
        ),
      ],
    );
  }
}
