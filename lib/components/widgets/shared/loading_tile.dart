import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Displays a shimmer animation to indicate a loading list.
class LoadingTile extends StatelessWidget {
  const LoadingTile({
    this.padding = const EdgeInsets.all(8),
  });

  final EdgeInsets padding;

  Widget _buildLine([double widthFactor = 1]) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        width: double.infinity,
        height: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500],
        highlightColor: Colors.white,
        blendMode: BlendMode.srcATop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(backgroundColor: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLine(1 / 6),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLine(3 / 4),
            const SizedBox(height: 16),
            _buildLine(3 / 4),
            const SizedBox(height: 16),
            _buildLine(),
          ],
        ),
      ),
    );
  }
}
