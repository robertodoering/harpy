import 'package:flutter/material.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

class ModalSheetHandle extends StatelessWidget {
  const ModalSheetHandle();

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        color: harpyTheme.foregroundColor.withOpacity(.2),
      ),
    );
  }
}
