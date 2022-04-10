import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

// TODO: don't show when in drawer or settings

class FloatingComposeButton extends ConsumerWidget {
  const FloatingComposeButton({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final general = ref.watch(generalPreferencesProvider);

    if (!general.floatingComposeButton) {
      return child;
    }

    final show = UserScrollDirection.scrollDirectionOf(context) ==
        ScrollDirection.forward;

    return Stack(
      children: [
        child,
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
