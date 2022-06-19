import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

/// Prevents exiting harpy when pressing the back button once.
class WillPopHarpy extends ConsumerStatefulWidget {
  const WillPopHarpy({
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<WillPopHarpy> createState() => _WillPopHarpyState();
}

class _WillPopHarpyState extends ConsumerState<WillPopHarpy> {
  bool _willPop = false;

  Future<void> _updateWillPop() async {
    _willPop = true;
    await Future<void>.delayed(const Duration(seconds: 5));
    _willPop = false;
  }

  Future<bool> _onWillPop() async {
    // if the current pop request will close the application
    if (!Navigator.of(context).canPop()) {
      if (_willPop) {
        return true;
      } else {
        ref.read(messageServiceProvider).showSnackbar(
              const SnackBar(content: Text('press back again to exit harpy')),
            );

        _updateWillPop().ignore();
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
