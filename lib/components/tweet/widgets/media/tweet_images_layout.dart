import 'package:flutter/material.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

typedef OnImageTap = void Function(int index);
typedef OnImageLongPress = void Function(int index);

/// Builds the layout for up to four tweet images.
class TweetImagesLayout extends StatelessWidget {
  const TweetImagesLayout({
    @required this.children,
    this.onImageTap,
    this.onImageLongPress,
    this.padding = 2,
  });

  final List<Widget> children;
  final OnImageTap onImageTap;
  final OnImageLongPress onImageLongPress;
  final double padding;

  // I don't want to add a BuildContext paramter to this method.
  // But i need the BuildContext to show the BottomSheetModal.
  // Is it dity to add this parameter?
  Widget _buildChild(
    int index, {
    bool topLeft = false,
    bool bottomLeft = false,
    bool topRight = false,
    bool bottomRight = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? kDefaultRadius : Radius.zero,
        bottomLeft: bottomLeft ? kDefaultRadius : Radius.zero,
        topRight: topRight ? kDefaultRadius : Radius.zero,
        bottomRight: bottomRight ? kDefaultRadius : Radius.zero,
      ),
      child: GestureDetector(
        onTap: () => onImageTap?.call(index),
        onLongPress: () => onImageLongPress?.call(index),
        child: children[index],
      ),
    );
  }

  Widget _buildOne() {
    return _buildChild(
      0,
      topLeft: true,
      bottomLeft: true,
      topRight: true,
      bottomRight: true,
    );
  }

  Widget _buildTwo() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildChild(0, topLeft: true, bottomLeft: true)),
        SizedBox(width: padding),
        Expanded(child: _buildChild(1, topRight: true, bottomRight: true)),
      ],
    );
  }

  Widget _buildThree() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildChild(0, topLeft: true, bottomLeft: true)),
        SizedBox(width: padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(child: _buildChild(1, topRight: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(2, bottomRight: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFour() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(child: _buildChild(0, topLeft: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(2, bottomLeft: true)),
            ],
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(child: _buildChild(1, topRight: true)),
              SizedBox(height: padding),
              Expanded(child: _buildChild(3, bottomRight: true)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children.length == 1) {
      return _buildOne();
    } else if (children.length == 2) {
      return _buildTwo();
    } else if (children.length == 3) {
      return _buildThree();
    } else if (children.length == 4) {
      return _buildFour();
    } else {
      return const SizedBox();
    }
  }
}
