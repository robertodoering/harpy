import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';

/// Prevents exiting harpy when pressing the back button once.
class WillPopHarpy extends StatefulWidget {
  const WillPopHarpy({
    required this.child,
  });

  final Widget child;

  @override
  _WillPopHarpyState createState() => _WillPopHarpyState();
}

class _WillPopHarpyState extends State<WillPopHarpy> {
  bool _willPop = false;

  void _updateWillPop() {
    _willPop = true;
    Future<void>.delayed(const Duration(seconds: 5)).then(
      (_) => _willPop = false,
    );
  }

  Future<bool> _onWillPop() async {
    // if the current pop request will close the application
    if (!Navigator.of(context).canPop()) {
      if (_willPop) {
        return true;
      } else {
        app<MessageService>().show('press back again to exit harpy');
        _updateWillPop();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}
