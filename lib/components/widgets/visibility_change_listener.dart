import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Uses a [VisibilityDetector] to detect whenever the [child] enters or leaves
/// the view.
///
/// Additional callbacks can be added using the [VisibilityChange] inherited
/// widget.
class VisibilityChangeListener extends StatefulWidget {
  const VisibilityChangeListener({
    required this.detectorKey,
    required this.child,
    this.onVisibilityChanged,
  });

  final Key detectorKey;
  final Widget child;

  final ValueChanged<bool>? onVisibilityChanged;

  @override
  State<VisibilityChangeListener> createState() =>
      _VisibilityChangeListenerState();
}

class _VisibilityChangeListenerState extends State<VisibilityChangeListener> {
  final List<ValueChanged<bool>> _callbacks = [];

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    if (widget.onVisibilityChanged != null) {
      _callbacks.add(widget.onVisibilityChanged!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // makes sure we trigger the visibility detector initially to update this
      // listener's visibility
      VisibilityDetectorController.instance.notifyNow();
    });
  }

  void _updateVisibility(bool visible) {
    _visible = visible;

    if (mounted) {
      for (final callback in _callbacks) {
        callback(visible);
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_visible && info.visibleBounds.height > 0) {
      _updateVisibility(true);
    } else if (_visible && info.visibleBounds.height == 0) {
      _updateVisibility(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: VisibilityChange(
        isVisible: _visible,
        addCallback: _callbacks.add,
        removeCallback: _callbacks.remove,
        child: widget.child,
      ),
    );
  }
}

/// Inherited widget to add and remove visibility change callbacks.
class VisibilityChange extends InheritedWidget {
  const VisibilityChange({
    required this.isVisible,
    required this.addCallback,
    required this.removeCallback,
    required super.child,
  });

  final bool isVisible;

  final void Function(ValueChanged<bool> callback) addCallback;
  final void Function(ValueChanged<bool> callback) removeCallback;

  static VisibilityChange? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VisibilityChange>();
  }

  @override
  bool updateShouldNotify(covariant VisibilityChange oldWidget) {
    return false;
  }
}
