import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Displays a shimmer animation to indicate a loading list for tweet tiles.
class LoadingTweetTile extends StatelessWidget {
  const LoadingTweetTile({
    this.padding = const EdgeInsets.all(8),
  });

  final EdgeInsets padding;

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
                      const _LoadingLine(1 / 6),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _LoadingLine(3 / 4),
            const SizedBox(height: 16),
            const _LoadingLine(3 / 4),
            const SizedBox(height: 16),
            const _LoadingLine(),
          ],
        ),
      ),
    );
  }
}

/// Displays a shimmer animation to indicate a loading list for user tiles.
class LoadingUserTile extends StatelessWidget {
  const LoadingUserTile();

  Widget _buildRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(backgroundColor: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _LoadingLine(2 / 3),
              const SizedBox(height: 8),
              const _LoadingLine(1 / 2),
            ],
          ),
        ),
        const Expanded(
          child: _LoadingLine(4 / 5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500],
        highlightColor: Colors.white,
        blendMode: BlendMode.srcATop,
        child: Column(
          children: <Widget>[
            _buildRow(),
            const SizedBox(height: 16),
            _buildRow(),
            const SizedBox(height: 16),
            _buildRow(),
          ],
        ),
      ),
    );
  }
}

class _LoadingLine extends StatelessWidget {
  const _LoadingLine([this.widthFactor = 1]);

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
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
}
