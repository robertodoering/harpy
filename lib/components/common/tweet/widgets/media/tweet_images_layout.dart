import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

typedef OnImageTap = void Function(int index);
typedef OnImageLongPress = void Function(int index, BuildContext context);

/// Builds the layout for up to four tweet images.
class TweetImagesLayout extends StatelessWidget {
  const TweetImagesLayout({
    required this.children,
    this.onImageTap,
    this.onImageLongPress,
    this.padding = 2,
  });

  final List<Widget> children;
  final OnImageTap? onImageTap;
  final OnImageLongPress? onImageLongPress;
  final double padding;

  Widget _buildChild(
    int index,
    BuildContext context, {
    bool topLeft = false,
    bool bottomLeft = false,
    bool topRight = false,
    bool bottomRight = false,
  }) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? kRadius : Radius.zero,
        bottomLeft: bottomLeft ? kRadius : Radius.zero,
        topRight: topRight ? kRadius : Radius.zero,
        bottomRight: bottomRight ? kRadius : Radius.zero,
      ),
      child: GestureDetector(
        onTap: () => onImageTap?.call(index),
        onLongPress: () => onImageLongPress?.call(index, context),
        child: children[index],
      ),
    );
  }

  Widget _buildOne(BuildContext context) {
    return _buildChild(
      0,
      context,
      topLeft: true,
      bottomLeft: true,
      topRight: true,
      bottomRight: true,
    );
  }

  Widget _buildTwo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildChild(
            0,
            context,
            topLeft: true,
            bottomLeft: true,
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: _buildChild(
            1,
            context,
            topRight: true,
            bottomRight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildThree(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildChild(0, context, topLeft: true, bottomLeft: true),
        ),
        SizedBox(width: padding),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildChild(1, context, topRight: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(2, context, bottomRight: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFour(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildChild(0, context, topLeft: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(2, context, bottomLeft: true)),
            ],
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildChild(1, context, topRight: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(3, context, bottomRight: true)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children.length == 1) {
      return _buildOne(context);
    } else if (children.length == 2) {
      return _buildTwo(context);
    } else if (children.length == 3) {
      return _buildThree(context);
    } else if (children.length == 4) {
      return _buildFour(context);
    } else {
      return const SizedBox();
    }
  }
}
