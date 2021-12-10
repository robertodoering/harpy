import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class FontCard extends StatelessWidget {
  const FontCard({
    required this.font,
    required this.style,
    required this.selected,
    required this.onSelect,
    required this.onConfirm,
    this.assetFont = false,
  });

  final String font;
  final TextStyle style;
  final bool selected;
  final bool assetFont;
  final VoidCallback onSelect;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyListCard(
      border: selected ? Border.all(color: theme.colorScheme.primary) : null,
      title: Text(font, style: style),
      trailing:
          isFree && !assetFont ? const FlareIcon.shiningStar(size: 22) : null,
      onTap: selected ? onConfirm : onSelect,
    );
  }
}
