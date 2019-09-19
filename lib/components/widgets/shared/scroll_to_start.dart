import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/implicit_animations.dart';
import 'package:harpy/components/widgets/shared/scroll_direction_listener.dart';
import 'package:harpy/core/misc/harpy_theme.dart';

/// A button at the bottom of the screen that listens to the
/// [ScrollDirection] and position to animate in or out of the screen.
///
/// Scrolls to the start of the list on tap.
///
/// The button is visible if the current scroll position is greater than the
/// screen size and the current scroll direction is [ScrollDirection.up].
class ScrollToStart extends StatefulWidget {
  const ScrollToStart({
    @required this.child,
    @required this.scrollController,
  });

  final Widget child;

  final ScrollController scrollController;

  @override
  _ScrollToStartState createState() => _ScrollToStartState();
}

class _ScrollToStartState extends State<ScrollToStart> {
  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    final mediaQuery = MediaQuery.of(context);

    // rebuild the button when scroll position is lower than the screen size
    // to hide the button when scrolling all the way up
    if (widget.scrollController.position.pixels < mediaQuery.size.height &&
        mounted) {
      setState(() {});
    }
  }

  bool get _show {
    final scrollDirection = ScrollDirection.of(context);
    final mediaQuery = MediaQuery.of(context);

    if (!widget.scrollController.hasClients) {
      return false;
    }

    return widget.scrollController.position.pixels > mediaQuery.size.height &&
        scrollDirection.up;
  }

  @override
  Widget build(BuildContext context) {
    final harpyTheme = HarpyTheme.of(context);

    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedShiftedPosition(
            shift: _show ? Offset.zero : const Offset(0, 1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: RaisedHarpyButton(
                icon: Icons.arrow_upward,
                dense: true,
                backgroundColor: harpyTheme.backgroundColors.last,
                onTap: () => widget.scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
