import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Builds the first page for the [SetupPage].
class SetupWelcomeContent extends ConsumerStatefulWidget {
  const SetupWelcomeContent({
    required this.onStart,
  });

  final VoidCallback onStart;

  @override
  ConsumerState<SetupWelcomeContent> createState() =>
      _SetupWelcomeContentState();
}

class _SetupWelcomeContentState extends ConsumerState<SetupWelcomeContent>
    with AutomaticKeepAliveClientMixin {
  // keep state even when scrolling off-screen in the page view
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final authentication = ref.watch(authenticationStateProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.base * 2),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImmediateSlideAnimation(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  begin: const Offset(0, .75),
                  child: ImmediateOpacityAnimation(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    child: Text(
                      'welcome',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                VerticalSpacer.normal,
                VerticalSpacer.normal,
                ImmediateSlideAnimation(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.easeOutCubic,
                  begin: const Offset(0, .75),
                  child: ImmediateOpacityAnimation(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 1600),
                    curve: Curves.easeOutCubic,
                    child: FittedBox(
                      child: Text(
                        authentication.user!.name,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: harpyTheme.colors.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalSpacer.normal,
          ImmediateSlideAnimation(
            delay: const Duration(milliseconds: 2400),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            begin: const Offset(0, .5),
            child: ImmediateOpacityAnimation(
              delay: const Duration(milliseconds: 2400),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              child: Text(
                "let's take a moment to setup your experience",
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          VerticalSpacer.normal,
          Expanded(
            child: ImmediateScaleAnimation(
              delay: const Duration(milliseconds: 2800),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.elasticOut,
              child: Center(
                child: RbyButton.text(
                  label: const Text('start'),
                  onTap: widget.onStart,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
