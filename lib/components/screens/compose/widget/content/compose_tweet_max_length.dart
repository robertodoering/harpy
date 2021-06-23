import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds the count of weighted tweet characters in the composed tweet with the
/// max length of 280 characters.
class ComposeTweetMaxLenght extends StatefulWidget {
  const ComposeTweetMaxLenght({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  _ComposeTweetMaxLenghtState createState() => _ComposeTweetMaxLenghtState();
}

class _ComposeTweetMaxLenghtState extends State<ComposeTweetMaxLenght> {
  late String _text;

  @override
  void initState() {
    super.initState();

    _text = widget.controller.text;
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    final text = widget.controller.text;

    if (text != _text) {
      setState(() {
        _text = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final count = tweetTextCount(widget.controller.text);

    final style = count <= 280
        ? theme.textTheme.bodyText1
        : theme.textTheme.bodyText1?.copyWith(color: theme.errorColor);

    return Text('$count / 280', style: style);
  }
}
