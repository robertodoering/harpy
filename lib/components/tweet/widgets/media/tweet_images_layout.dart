import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

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
    switch (children.length) {
      case 1:
        return _SingleImageLayout(
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          child: children.single,
        );
      case 2:
        return _TwoImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
      case 3:
        return _ThreeImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
      case 4:
        return _FourImagesLayout(
          betweenPadding: betweenPadding,
          onImageTap: onImageTap,
          onImageLongPress: onImageLongPress,
          children: children,
        );
      default:
        return const SizedBox();
    }
  }
}

class _ImageWrapper extends ConsumerWidget {
  const _ImageWrapper({
    required this.index,
    required this.onImageTap,
    required this.onImageLongPress,
    required this.child,
    this.topLeft = false,
    this.bottomLeft = false,
    this.topRight = false,
    this.bottomRight = false,
  });

  final int index;
  final IndexedVoidCallback? onImageTap;
  final IndexedVoidCallback? onImageLongPress;
  final Widget child;
  final bool topLeft;
  final bool bottomLeft;
  final bool topRight;
  final bool bottomRight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? harpyTheme.radius : Radius.zero,
        bottomLeft: bottomLeft ? harpyTheme.radius : Radius.zero,
        topRight: topRight ? harpyTheme.radius : Radius.zero,
        bottomRight: bottomRight ? harpyTheme.radius : Radius.zero,
      ),
      child: GestureDetector(
        onTap: onImageTap != null ? () => onImageTap?.call(index) : null,
        onLongPress: onImageLongPress != null
            ? () => onImageLongPress?.call(index)
            : null,
        child: child,
      ),
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
      topLeft: true,
      topRight: true,
      bottomLeft: true,
      bottomRight: true,
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
            topLeft: true,
            bottomLeft: true,
            onImageTap: onImageTap,
            onImageLongPress: onImageLongPress,
            child: children[0],
          ),
        ),
        SizedBox(width: betweenPadding),
        Expanded(
          child: _ImageWrapper(
            index: 1,
            topRight: true,
            bottomRight: true,
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
            topLeft: true,
            bottomLeft: true,
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
                  topRight: true,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[1],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 2,
                  bottomRight: true,
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
                  topLeft: true,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[0],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 2,
                  bottomLeft: true,
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
                  topRight: true,
                  onImageTap: onImageTap,
                  onImageLongPress: onImageLongPress,
                  child: children[1],
                ),
              ),
              SizedBox(height: betweenPadding),
              Expanded(
                child: _ImageWrapper(
                  index: 3,
                  bottomRight: true,
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
