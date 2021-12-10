import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme.dart';

class PlaceholderBox extends StatelessWidget {
  const PlaceholderBox({
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.shape = BoxShape.rectangle,
    this.alignment = Alignment.center,
  });

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final BoxShape shape;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: shape == BoxShape.circle ? null : kBorderRadius,
          shape: shape,
          color: theme.cardTheme.color,
        ),
      ),
    );
  }
}
