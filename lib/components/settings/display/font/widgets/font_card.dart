import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class FontCard extends StatefulWidget {
  const FontCard({
    required this.font,
    required this.style,
    required this.onPreview,
    required this.selected,
    required this.previewed,
    this.assetFont = false,
  });

  final String font;
  final TextStyle style;
  final bool selected;
  final bool previewed;
  final bool assetFont;
  final VoidCallback onPreview;

  @override
  State<FontCard> createState() => _FontCardState();
}

class _FontCardState extends State<FontCard> {
  late bool _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyListCard(
      border: widget.previewed
          ? Border.all(color: theme.colorScheme.primary)
          : _selected
              ? Border.all(color: theme.colorScheme.secondary)
              : null,
      title: Text(widget.font, style: widget.style),
      trailing: Harpy.isFree && !widget.assetFont
          ? const FlareIcon.shiningStar(size: 22)
          : null,
      onTap: (widget.previewed) && (Harpy.isPro || widget.assetFont)
          ? () {
              // update border during screen transition
              setState(() => _selected = true);
              Navigator.of(context).pop(widget.font);
            }
          : widget.onPreview,
    );
  }
}
