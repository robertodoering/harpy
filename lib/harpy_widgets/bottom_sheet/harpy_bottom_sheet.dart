import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedantic/pedantic.dart';

/// Shows a harpy styled modal bottom sheet with the [children] in a scroll
/// view.
Future<T?> showHarpyBottomSheet<T>(
  BuildContext context, {
  required List<Widget> children,
  bool hapticFeedback = true,
}) async {
  if (hapticFeedback) {
    unawaited(HapticFeedback.lightImpact());
  }

  return showMaterialModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: kRadius,
        topRight: kRadius,
      ),
    ),
    builder: (context) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetHandle(),
            ...children,
          ],
        ),
      ),
    ),
  );
}
