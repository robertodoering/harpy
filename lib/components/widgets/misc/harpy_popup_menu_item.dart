import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a [HarpyButton] as a [PopupMenuEntry] for a [PopupMenuButton].
class HarpyPopupMenuItem<T> extends PopupMenuEntry<T> {
  const HarpyPopupMenuItem({
    this.value,
    this.enabled = true,
    this.icon,
    this.text,
  });

  /// The value that will be returned by [showMenu] if this entry is selected.
  final T? value;

  /// Whether the user is permitted to select this item.
  final bool enabled;

  final Widget? icon;
  final Widget? text;

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(T? value) => value == this.value;

  @override
  HarpyPopupMenuItemState<T, HarpyPopupMenuItem<T>> createState() =>
      HarpyPopupMenuItemState<T, HarpyPopupMenuItem<T>>();
}

class HarpyPopupMenuItemState<T, W extends HarpyPopupMenuItem<T>>
    extends State<W> {
  @override
  Widget build(BuildContext context) {
    return HarpyButton.flat(
      icon: widget.icon,
      iconSize: 20,
      text: widget.text,
      dense: true,
      onTap: widget.enabled
          ? () => Navigator.of(context).pop<T>(widget.value)
          : null,
    );
  }
}
