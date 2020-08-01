import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_shifted_position.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController ??= PrimaryScrollController.of(context)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(_scrollListener);
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
  bool get _show {
    final ScrollDirection scrollDirection = ScrollDirection.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    if (!_scrollController.hasClients) {
      return false;
    }

    return _scrollController.offset > mediaQuery.size.height &&
        scrollDirection.up;
  }

  void _scrollToStart() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    if (_scrollController.offset > mediaQuery.size.height * 5) {
      // .1 to prevent a refresh indicator to fire when jumping to the start
      _scrollController.jumpTo(.1);
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
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedOpacity(
            opacity: _show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: AnimatedShiftedPosition(
              shift: _show ? Offset.zero : const Offset(0, 1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HarpyButton.raised(
                  text: 'Jump to top',
                  icon: Icons.arrow_upward,
                  backgroundColor: harpyTheme.backgroundColors.last,
                  dense: true,
                  onTap: _scrollToStart,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
