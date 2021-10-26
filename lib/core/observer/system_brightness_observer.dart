import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Builds a [WidgetsBindingObserver] that listens to system brightness changes
/// and provides descendants with the current system brightness with a
/// [Provider<Brightness>].
///
/// We use this instead of [MediaQuery.platformBrightnessOf] to react on system
/// brightness changes while the app is running.
class SystemBrightnessObserver extends StatefulWidget {
  const SystemBrightnessObserver({
    required this.child,
  });

  final Widget child;

  @override
  _SystemBrightnessObserverState createState() =>
      _SystemBrightnessObserverState();
}

class _SystemBrightnessObserverState extends State<SystemBrightnessObserver>
    with WidgetsBindingObserver {
  Brightness _systemBrightness = Brightness.light;

  Brightness get _currentBrightness =>
      WidgetsBinding.instance?.platformDispatcher.platformBrightness ??
      Brightness.light;

  @override
  void initState() {
    super.initState();

    _systemBrightness = _currentBrightness;

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = _currentBrightness;

    if (_systemBrightness != brightness) {
      setState(() {
        _systemBrightness = brightness;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Brightness>.value(
      value: _systemBrightness,
      child: widget.child,
    );
  }
}
