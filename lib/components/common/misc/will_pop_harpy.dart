import 'package:flutter/material.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';

/// Prevents exiting harpy when pressing the back button once.
class WillPopHarpy extends StatefulWidget {
  const WillPopHarpy({
    @required this.child,
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
    if (_willPop) {
      return true;
    } else {
      app<MessageService>().show('press back again to exit harpy');
      _updateWillPop();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}
