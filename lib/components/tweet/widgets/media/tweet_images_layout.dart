import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef IndexedVoidCallback = void Function(int index);

/// Builds the layout for up to four tweet images.
class TweetImagesLayout extends StatelessWidget {
  const TweetImagesLayout({
    required this.children,
    this.onImageTap,
    this.onImageLongPress,
    this.betweenPadding = 2,
  }) : assert(children.length > 0 && children.length <= 4);

  final List<Widget> children;
  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final double betweenPadding;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (children.length) {
      case 1:
        child = _SingleImageLayout(
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          child: children.single,
        );
        break;
      case 2:
        child = _TwoImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
        break;
      case 3:
        child = _ThreeImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
        break;
      case 4:
        child = _FourImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
        break;
      default:
        assert(false);
        return const SizedBox();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // wrap the child in an empty gesture detector to avoid a tap in between
      // images to propagate
      onTap: () {},
      child: child,
    );
  }
}

class _ImageWrapper extends ConsumerWidget {
  const _ImageWrapper({
    required this.index,
    required this.onImageTap,
    required this.onImageLongPress,
    required this.child,
  });

  final int index;
  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onImageTap != null ? () => onImageTap?.call(index) : null,
      onLongPress:
          onImageLongPress != null ? () => onImageLongPress?.call(index) : null,
      child: child,
    );
  }
}

class _SingleImageLayout extends StatelessWidget {
  const _SingleImageLayout({
    required this.onImageTap,
    required this.onImageLongPress,
    required this.child,
  });

  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ImageWrapper(
      index: 0,
      onImageTap: onImageTap,
      onImageLongPress: onImageLongPress,
      child: child,
    );
  }
}

class _TwoImagesLayout extends StatelessWidget {
  const _TwoImagesLayout({
    required this.onImageTap,
    required this.onImageLongPress,
    required this.betweenPadding,
    required this.children,
  });

  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final double betweenPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ImageWrapper(
            index: 0,
            onImageTap: onImageTap,
            onImageLongPress: onImageLongPress,
            child: children[0],
          ),
        ),
        SizedBox(width: betweenPadding),
        Expanded(
          child: _ImageWrapper(
            index: 1,
            onImageTap: onImageTap,
            onImageLongPress: onImageLongPress,
            child: children[1],
          ),
        ),
      ],
    );
  }
}

class _ThreeImagesLayout extends StatelessWidget {
  const _ThreeImagesLayout({
    required this.onImageTap,
    required this.onImageLongPress,
    required this.betweenPadding,
    required this.children,
  });

  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final double betweenPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ImageWrapper(
            index: 0,
            onImageTap: onImageTap,
            onImageLongPress: onImageLongPress,
            child: children[0],
          ),
        ),
        SizedBox(width: betweenPadding),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _ImageWrapper(
                  index: 1,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[1],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 2,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[2],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FourImagesLayout extends StatelessWidget {
  const _FourImagesLayout({
    required this.onImageTap,
    required this.onImageLongPress,
    required this.betweenPadding,
    required this.children,
  });

  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final double betweenPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _ImageWrapper(
                  index: 0,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[0],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 2,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[2],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: betweenPadding),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _ImageWrapper(
                  index: 1,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[1],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 3,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[3],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
