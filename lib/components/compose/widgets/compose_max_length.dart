import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds the count of weighted tweet characters in the composed tweet with the
/// max length of 280 characters.
class ComposeMaxLength extends StatefulWidget {
  const ComposeMaxLength({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  State<ComposeMaxLength> createState() => _ComposeMaxLengthState();
}

class _ComposeMaxLengthState extends State<ComposeMaxLength> {
  late String _text;
  late int _count;

  @override
  void initState() {
    super.initState();

    _text = widget.controller.text;
    _count = tweetTextCount(_text);

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    final text = widget.controller.text;

    if (mounted && text != _text) {
      setState(() {
        _text = text;
        _count = tweetTextCount(_text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = _count <= 280
        ? theme.textTheme.bodyLarge
        : theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error);

    return Text('$_count / 280', style: style);
  }
}
