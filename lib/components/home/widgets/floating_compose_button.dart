import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class FloatingComposeButton extends ConsumerStatefulWidget {
  const FloatingComposeButton({
    required this.child,
  });

  final Widget child;

  @override
  _FloatingComposeButtonState createState() => _FloatingComposeButtonState();
}

class _FloatingComposeButtonState extends ConsumerState<FloatingComposeButton> {
  TabController? _controller;

  bool _show = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = HomeTabController.of(context)!..addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.removeListener(_listener);
  }

  void _listener() {
    if (mounted) {
      final show = _controller!.index != 0 &&
          _controller!.index != _controller!.length - 1;

      if (_show != show) setState(() => _show = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    final general = ref.watch(generalPreferencesProvider);

    if (!general.floatingComposeButton) return widget.child;

    final show = _show &&
        UserScrollDirection.scrollDirectionOf(context) !=
            ScrollDirection.reverse;

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.bottomRight,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: kShortAnimationDuration,
            child: AnimatedSlide(
              offset: show ? Offset.zero : const Offset(0, 1),
              curve: Curves.easeInOut,
              duration: kShortAnimationDuration,
              child: const _ComposeButton(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComposeButton extends ConsumerWidget {
  const _ComposeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final router = ref.watch(routerProvider);
    final display = ref.watch(displayPreferencesProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final bottomPadding = general.bottomAppBar
        ? HomeAppBar.height(context, ref.read) + display.paddingValue
        : display.paddingValue + mediaQuery.padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        right: display.paddingValue,
      ),
      child: Material(
        color: harpyTheme.colors.alternateCardColor,
        borderRadius: harpyTheme.borderRadius,
        child: InkWell(
          borderRadius: harpyTheme.borderRadius,
          onTap: () => router.goNamed(ComposePage.name),
          child: Padding(
            padding: display.edgeInsets,
            child: const Icon(FeatherIcons.feather),
          ),
        ),
      ),
    );
  }
}
