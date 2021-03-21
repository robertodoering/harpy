import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

import 'bottom_sheet_handle.dart';

/// Shows a harpy styled modal bottom sheet with the [children] in a column.
Future<T> showHarpyBottomSheet<T>(
  BuildContext context, {
  @required List<Widget> children,
}) async {
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
