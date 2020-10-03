import 'package:flutter/material.dart';

/// Wraps the [child] with a [Scaffold] to show [SnackBar]s from anywhere in the
/// app using the [globalKey].
class HarpyMessage extends StatefulWidget {
  HarpyMessage({
    @required this.child,
  }) : super(key: globalKey);

  final Widget child;

  static final GlobalKey<HarpyMessageState> globalKey =
      GlobalKey<HarpyMessageState>();

  @override
  HarpyMessageState createState() => HarpyMessageState();
}

class HarpyMessageState extends State<HarpyMessage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void show(String message, [SnackBarAction action]) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.child,
    );
  }
}
