import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_shifted_position.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';

/// Builds a button at the bottom of the screen that listens to the
/// [ScrollDirection] and animates in or out of the screen to provide a button
/// to jump to the start of the list.
///
/// The affected list must be built above this widget in the widget tree.
/// Only one primary scroll controller must exist below this widget.
///
/// The button is visible if the current scroll position is greater than the
/// screen size and the current scroll direction is [ScrollDirection.up].
class ScrollToStart extends StatefulWidget {
  const ScrollToStart({
    @required this.child,
  });

  final Widget child;

  @override
  _ScrollToStartState createState() => _ScrollToStartState();
}

class _ScrollToStartState extends State<ScrollToStart> {
  ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController ??= PrimaryScrollController.of(context);
    _scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController?.removeListener(_scrollListener);
  }

  void _scrollListener() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    // rebuild the button when scroll position is lower than the screen size
    // to hide the button when scrolling all the way up
    if (_scrollController.offset < mediaQuery.size.height && mounted) {
      setState(() {});
    }
  }

  /// Determines if the button should show.
  bool _show(MediaQueryData mediaQuery, ScrollDirection scrollDirection) {
    if (_scrollController == null || !_scrollController.hasClients) {
      return false;
    }

    return _scrollController.offset > mediaQuery.size.height &&
        scrollDirection?.up == true;
  }

  void _scrollToStart(MediaQueryData mediaQuery) {
    if (_scrollController.offset > mediaQuery.size.height * 5) {
      // We use animateTo instead of jumpTo because jumpTo(0) will cause the
      // refresh indicator to trigger.
      _scrollController.animateTo(
        0,
        duration: const Duration(microseconds: 1),
        curve: Curves.linear,
      );
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScrollDirection scrollDirection = ScrollDirection.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final bool show = _show(mediaQuery, scrollDirection);

    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: kShortAnimationDuration,
            child: AnimatedShiftedPosition(
              shift: show ? Offset.zero : const Offset(0, 1),
              hideOnCompletion: !show,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HarpyButton.raised(
                  text: const Text('Jump to top'),
                  icon: const Icon(Icons.arrow_upward),
                  backgroundColor: theme.cardColor,
                  dense: true,
                  onTap: () => _scrollToStart(mediaQuery),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
