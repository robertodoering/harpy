import 'package:flutter/cupertino.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

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
    required this.child,
    this.text,
    this.controller,
  });

  final Widget child;
  final Widget? text;
  final ScrollController? controller;

  @override
  _ScrollToStartState createState() => _ScrollToStartState();
}

class _ScrollToStartState extends State<ScrollToStart> {
  ScrollController? _controller;

  // ignore: invalid_use_of_protected_member
  bool get _hasSingleScrollPosition => _controller!.positions.length == 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller = widget.controller ?? PrimaryScrollController.of(context);

      assert(_controller != null, 'scroll to start has no scroll controller');
      _controller?.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.removeListener(_scrollListener);
  }

  void _scrollListener() {
    final mediaQuery = MediaQuery.of(context);

    // rebuild the button when scroll position is lower than the screen size
    // to hide the button when scrolling all the way up

    if (_hasSingleScrollPosition &&
        _controller!.offset < mediaQuery.size.height &&
        mounted) {
      setState(() {});
    }
  }

  bool _show(MediaQueryData mediaQuery, ScrollDirection? scrollDirection) {
    if (_controller == null || !_controller!.hasClients) {
      return false;
    }

    return _hasSingleScrollPosition &&
        _controller!.offset > mediaQuery.size.height &&
        scrollDirection != null &&
        scrollDirection.up;
  }

  void _scrollToStart(MediaQueryData mediaQuery) {
    if (!_hasSingleScrollPosition ||
        _controller!.offset > mediaQuery.size.height * 5) {
      // jumpTo(0) will cause the refresh indicator to trigger.
      // TODO: fixed in flutter:master, change to jumpTo(0) when it hits stable
      // https://github.com/flutter/flutter/issues/26833
      _controller!.jumpTo(1);
    } else {
      _controller!.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    final mediaQuery = MediaQuery.of(context);
    final scrollDirection = ScrollDirection.of(context);
    final harpyTheme = context.watch<HarpyTheme>();
    final config = context.watch<ConfigCubit>().state;

    final show = _show(mediaQuery, scrollDirection);

    final padding = config.bottomAppBar && route == HomeScreen.route
        ? HomeAppBar.height(context) + config.paddingValue
        : config.paddingValue + mediaQuery.padding.bottom;

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: kShortAnimationDuration,
            child: AnimatedShiftedPosition(
              shift: show ? Offset.zero : const Offset(0, 1),
              child: Padding(
                padding: EdgeInsets.only(bottom: padding),
                child: HarpyButton.raised(
                  padding: config.edgeInsets,
                  icon: Icon(
                    CupertinoIcons.arrow_up,
                    color: harpyTheme.foregroundColor,
                  ),
                  text: widget.text,
                  backgroundColor: harpyTheme.alternateCardColor,
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
