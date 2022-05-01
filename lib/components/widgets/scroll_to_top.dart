import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Builds a button at the bottom of the screen that animate in or out of the
/// screen based on the scroll offset and direction.
///
/// A [ScrollDirectionListener] must be built above this widget to provide the
/// current [ScrollDirection].
///
/// If no [controller] is provided, a [PrimaryScrollController] must be
/// available to be used.
class ScrollToTop extends ConsumerStatefulWidget {
  const ScrollToTop({
    required this.child,
    this.content,
    this.bottomPadding,
    this.controller,
  });

  final Widget child;
  final Widget? content;
  final double? bottomPadding;
  final ScrollController? controller;

  @override
  _ScrollToTopState createState() => _ScrollToTopState();
}

class _ScrollToTopState extends ConsumerState<ScrollToTop> {
  ScrollController? _controller;
  bool _show = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= (widget.controller ?? PrimaryScrollController.of(context))
      ?..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller == null) return;
    if (!mounted) return;
    assert(_controller!.hasClients);
    if (_controller!.positions.length != 1) return;

    final mediaQuery = MediaQuery.of(context);
    final scrollDirection = UserScrollDirection.scrollDirectionOf(context);

    final show = _controller!.positions.first.pixels > mediaQuery.size.height &&
        scrollDirection == ScrollDirection.forward;

    if (mounted && show != _show) setState(() => _show = show);
  }

  void _scrollToTop() {
    if (_controller == null) return;

    final mediaQuery = MediaQuery.of(context);
    final animationOffsetLimit = mediaQuery.size.height * 5;

    final position = _controller!.positions.first;

    if (position.pixels > animationOffsetLimit) {
      position.jumpTo(0);
    } else {
      position.animateTo(
        0,
        duration: lerpDuration(
          const Duration(milliseconds: 500),
          const Duration(seconds: 1),
          mediaQuery.size.height / animationOffsetLimit,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedOpacity(
            opacity: _show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: kShortAnimationDuration,
            child: AnimatedSlide(
              offset: _show ? Offset.zero : const Offset(0, 1),
              curve: Curves.easeInOut,
              duration: kShortAnimationDuration,
              child: _ScrollToTopButton(
                onTap: _scrollToTop,
                content: widget.content,
                bottomPadding: widget.bottomPadding,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScrollToTopButton extends ConsumerWidget {
  const _ScrollToTopButton({
    required this.onTap,
    this.content,
    this.bottomPadding,
  });

  final VoidCallback onTap;
  final Widget? content;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return Padding(
      padding: display.edgeInsets.copyWith(
        bottom:
            bottomPadding ?? display.paddingValue + mediaQuery.padding.bottom,
      ),
      child: Material(
        color: harpyTheme.colors.alternateCardColor,
        borderRadius: harpyTheme.borderRadius,
        child: InkWell(
          borderRadius: harpyTheme.borderRadius,
          onTap: onTap,
          child: Padding(
            padding: display.edgeInsets,
            child: AnimatedSize(
              duration: kShortAnimationDuration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.arrow_up),
                  if (content != null) ...[smallHorizontalSpacer, content!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
