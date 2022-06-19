import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Shows a harpy styled modal bottom sheet with the [children] in a scroll
/// view.
Future<T?> showHarpyBottomSheet<T>(
  BuildContext context, {
  required HarpyTheme harpyTheme,
  required List<Widget> children,
}) async {
  HapticFeedback.lightImpact().ignore();

  return showMaterialModalBottomSheet<T>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: harpyTheme.radius,
        topRight: harpyTheme.radius,
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
