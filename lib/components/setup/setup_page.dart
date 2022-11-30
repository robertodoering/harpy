import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage();

  static const name = 'setup';

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  late final _connectionsProvider = legacyUserConnectionsProvider(
    ['harpy_app'].toBuiltList(),
  );

  final _controller = PageController();

  var _enableScroll = false;

  static const _delay = Duration(milliseconds: 3100);

  @override
  void initState() {
    super.initState();

    ref.read(_connectionsProvider.notifier).load();

    Future<void>.delayed(_delay).then(
      (_) {
        if (mounted) setState(() => _enableScroll = true);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final connections = ref.watch(_connectionsProvider).values.isNotEmpty
        ? ref.watch(_connectionsProvider).values.first
        : null;

    final children = [
      SetupWelcomeContent(
        onStart: () => _controller.nextPage(
          duration: theme.animation.long,
          curve: Curves.easeOutCubic,
        ),
      ),
      const SetupAppearanceContent(),
      SetupFinishContent(
        connections: connections,
        notifier: ref.watch(_connectionsProvider.notifier),
      ),
      if (isFree) const SetupProContent(),
    ];

    return HarpyScaffold(
      safeArea: true,
      child: AnimatedPadding(
        duration: theme.animation.short,
        padding: EdgeInsets.symmetric(vertical: theme.spacing.base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics:
                    _enableScroll ? null : const NeverScrollableScrollPhysics(),
                children: children,
              ),
            ),
            ImmediateSlideAnimation(
              delay: _delay,
              curve: Curves.easeOutCubic,
              duration: theme.animation.long,
              begin: const Offset(0, .5),
              child: ImmediateOpacityAnimation(
                delay: _delay,
                curve: Curves.easeOutCubic,
                duration: theme.animation.long,
                child: Stack(
                  children: [
                    _PageIndicator(
                      controller: _controller,
                      length: children.length,
                    ),
                    _SkipButton(controller: _controller),
                    _PrevButton(
                      controller: _controller,
                      length: children.length,
                    ),
                    _NextButton(
                      controller: _controller,
                      length: children.length,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.controller,
    required this.length,
  });

  final PageController controller;
  final int length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned.fill(
      child: Center(
        child: SmoothPageIndicator(
          controller: controller,
          count: length,
          effect: ExpandingDotsEffect(
            dotColor: theme.dividerColor,
            activeDotColor: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends ConsumerStatefulWidget {
  const _SkipButton({
    required this.controller,
  });

  final PageController controller;

  @override
  _SkipButtonState createState() => _SkipButtonState();
}

class _SkipButtonState extends ConsumerState<_SkipButton> {
  double _opacity = 1;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() => _opacity = (1 - widget.controller.page!).clamp(0, 1));
    }

    if (_opacity == 0) {
      // when the skip button is fully out of view once, hide it forever
      widget.controller.removeListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_opacity == 0) return const SizedBox();

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: theme.spacing.symmetric(horizontal: true),
        alignment: AlignmentDirectional.centerStart,
        child: RbyButton.text(
          padding: theme.spacing.edgeInsets,
          label: const Text('skip'),
          onTap: () => finishSetup(ref),
        ),
      ),
    );
  }
}

class _PrevButton extends ConsumerStatefulWidget {
  const _PrevButton({
    required this.controller,
    required this.length,
  });

  final PageController controller;
  final int length;

  @override
  _PrevButtonState createState() => _PrevButtonState();
}

class _PrevButtonState extends ConsumerState<_PrevButton> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() => _opacity = widget.controller.page!.clamp(0, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_opacity == 0) return const SizedBox();

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: theme.spacing.symmetric(horizontal: true),
        alignment: AlignmentDirectional.centerStart,
        child: RbyButton.text(
          padding: theme.spacing.edgeInsets,
          icon: const Icon(CupertinoIcons.chevron_left),
          onTap: () => widget.controller.animateToPage(
            (widget.controller.page! - 1).round().clamp(0, widget.length - 1),
            duration: theme.animation.long,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}

class _NextButton extends ConsumerStatefulWidget {
  const _NextButton({
    required this.controller,
    required this.length,
  });

  final PageController controller;
  final int length;

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends ConsumerState<_NextButton> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() {
        if (widget.controller.page! + 1 > widget.length - 1) {
          _opacity = (widget.length - widget.controller.page! - 1).clamp(0, 1);
        } else {
          _opacity = (widget.length - widget.controller.page!).clamp(0, 1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_opacity == 0) return const SizedBox();

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: theme.spacing.symmetric(horizontal: true),
        alignment: AlignmentDirectional.centerEnd,
        child: RbyButton.text(
          padding: theme.spacing.edgeInsets,
          icon: const Icon(CupertinoIcons.chevron_right),
          onTap: () => widget.controller.animateToPage(
            (widget.controller.page! + 1).round().clamp(0, widget.length),
            duration: theme.animation.long,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}

void finishSetup(WidgetRef ref) {
  HapticFeedback.lightImpact();
  ref.read(setupPreferencesProvider).performedSetup = true;
  ref.context.goNamed(HomePage.name);
}
