import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:pedantic/pedantic.dart';

/// Shows a harpy styled modal bottom sheet with the [children] in a column.
Future<T?> showHarpyBottomSheet<T>(
  BuildContext context, {
  required List<Widget> children,
  bool hapticFeedback = false,
}) async {
  if (hapticFeedback) {
    unawaited(HapticFeedback.lightImpact());
  }

  return showModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: kDefaultRadius,
        topRight: kDefaultRadius,
      ),
    ),
    builder: (BuildContext context) => SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const BottomSheetHandle(),
          ...children,
        ],
      ),
    ),
  );
}
