import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// A custom popup menu button that calls [showHarpyMenu] to show a menu.
class HarpyPopupMenuButton<T> extends ConsumerStatefulWidget {
  const HarpyPopupMenuButton({
    required this.itemBuilder,
    this.onSelected,
    this.onCancelled,
    this.enabled = true,
  });

  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final VoidCallback? onCancelled;
  final bool enabled;

  @override
  ConsumerState<HarpyPopupMenuButton<T>> createState() =>
      _HarpyPopupMenuButtonState<T>();
}

class _HarpyPopupMenuButtonState<T>
    extends ConsumerState<HarpyPopupMenuButton<T>> {
  void showButtonMenu() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final items = widget.itemBuilder(context);

    if (items.isNotEmpty) {
      showHarpyMenu(
        context: context,
        elevation: popupMenuTheme.elevation,
        items: items,
        position: position,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
      ).then((newValue) {
        if (!mounted) return;

        if (newValue == null) {
          widget.onCancelled?.call();
        } else {
          HapticFeedback.lightImpact();
          widget.onSelected?.call(newValue);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HarpyButton.icon(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      onTap: widget.enabled ? showButtonMenu : null,
    );
  }
}

class HarpyPopupMenuItem<T> extends PopupMenuEntry<T> {
  const HarpyPopupMenuItem({
    required this.value,
    this.leading,
    this.title,
    this.trailing,
    this.enabled = true,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  /// The value that will be returned by [showMenu] if this entry is selected.
  ///
  /// When `null`, [HarpyPopupMenuButton.onCancelled] will be called if this
  /// item is selected.
  final T? value;

  /// Whether the user is permitted to select this item.
  final bool enabled;

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
    return HarpyListTile(
      leading: widget.leading,
      title: widget.title,
      trailing: widget.trailing,
      borderRadius: BorderRadius.zero,
      onTap:
          widget.enabled ? () => Navigator.of(context).pop(widget.value) : null,
    );
  }
}
