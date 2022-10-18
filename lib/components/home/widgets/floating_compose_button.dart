import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class FloatingComposeButton extends ConsumerStatefulWidget {
  const FloatingComposeButton({
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<FloatingComposeButton> createState() =>
      _FloatingComposeButtonState();
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
    final theme = Theme.of(context);
    final general = ref.watch(generalPreferencesProvider);

    if (!general.floatingComposeButton) return widget.child;

    final show = _show &&
        UserScrollDirection.scrollDirectionOf(context) !=
            ScrollDirection.reverse;

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            curve: Curves.easeInOut,
            duration: theme.animation.short,
            child: AnimatedSlide(
              offset: show ? Offset.zero : const Offset(0, 1),
              curve: Curves.easeInOut,
              duration: theme.animation.short,
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
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final bottomPadding = general.bottomAppBar
        ? HomeAppBar.height(ref) + theme.spacing.base
        : theme.spacing.base + mediaQuery.padding.bottom;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: bottomPadding,
        end: theme.spacing.base,
      ),
      child: Material(
        color: harpyTheme.colors.alternateCardColor,
        borderRadius: theme.shape.borderRadius,
        child: InkWell(
          borderRadius: theme.shape.borderRadius,
          onTap: () => context.goNamed(ComposePage.name),
          child: Padding(
            padding: theme.spacing.edgeInsets,
            child: const Icon(FeatherIcons.feather),
          ),
        ),
      ),
    );
  }
}
