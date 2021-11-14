import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        color: theme.colorScheme.onBackground.withOpacity(.2),
      ),
    );
  }
}
