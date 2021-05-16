import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the current position as a text and updates it automatically.
class OverlayPositionText extends StatefulWidget {
  const OverlayPositionText(this.model);

  final HarpyVideoPlayerModel model;

  @override
  _OverlayPositionTextState createState() => _OverlayPositionTextState();
}

class _OverlayPositionTextState extends State<OverlayPositionText> {
  @override
  void initState() {
    super.initState();

    widget.model.controller!.addListener(_listener);
  }

  @override
  void dispose() {
    widget.model.controller!.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      prettyPrintDuration(widget.model.position),
      style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.white),
    );
  }
}
