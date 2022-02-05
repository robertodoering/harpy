import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Calls the [onVisibilityChanged] callback whenever the [child] enters or
/// leaves the view.
///
/// Additional callbacks can be added using the [VisibilityChange] inherited
/// widget using [VisibilityChange.of(context).addOnVisibilityChanged].
class VisibilityChangeDetector extends StatefulWidget {
  const VisibilityChangeDetector({
    required Key? key,
    required this.child,
    this.onVisibilityChanged,
  }) : super(key: key);

  final Widget child;

  final ValueChanged<bool>? onVisibilityChanged;

  @override
  _VisibilityChangeDetectorState createState() =>
      _VisibilityChangeDetectorState();
}

class _VisibilityChangeDetectorState extends State<VisibilityChangeDetector> {
  final List<ValueChanged<bool>> _onChanged = [];

  bool visible = false;

  @override
  void initState() {
    super.initState();

    if (widget.onVisibilityChanged != null) {
      _onChanged.add(widget.onVisibilityChanged!);
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // makes sure the onVisibilityChanged callback gets called for the newly
      // created widget
      VisibilityDetectorController.instance.notifyNow();
    });
  }

  void addOnVisibilityChanged(ValueChanged<bool> callback) {
    _onChanged.add(callback);
  }

  void removeOnVisibilityChanged(ValueChanged<bool> callback) {
    _onChanged.remove(callback);
  }

  void _changeVisible(bool value) {
    visible = value;
    if (mounted) {
      for (final callback in _onChanged) {
        callback(value);
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!visible && info.visibleBounds.height > 0) {
      // child came into view
      _changeVisible(true);
    } else if (visible && info.visibleBounds.height == 0) {
      // child left view
      _changeVisible(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: _onVisibilityChanged,
      child: VisibilityChange(
        visibilityDetector: this,
        child: widget.child,
      ),
    );
  }
}

/// Inherited widget built by [VisibilityChangeDetector] to access the
/// [_VisibilityChangeDetectorState].
class VisibilityChange extends InheritedWidget {
  const VisibilityChange({
    required this.visibilityDetector,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final _VisibilityChangeDetectorState visibilityDetector;

  static VisibilityChange? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VisibilityChange>();
  }

  void addOnVisibilityChanged(ValueChanged<bool> callback) {
    visibilityDetector.addOnVisibilityChanged(callback);
  }

  void removeOnVisibilityChanged(ValueChanged<bool> callback) {
    visibilityDetector.removeOnVisibilityChanged(callback);
  }

  @override
  bool updateShouldNotify(VisibilityChange oldWidget) => false;
}
