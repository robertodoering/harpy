import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Shown to new users upon logging in for the first time.
class SetupScreen extends StatefulWidget {
  const SetupScreen();

  static const route = 'setup';

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _controller = PageController();

  var _enableScroll = false;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(milliseconds: 3100)).then(
      (_) {
        if (mounted) {
          setState(() => _enableScroll = true);
        }
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
    final config = context.watch<ConfigCubit>().state;

    final children = [
      SetupWelcomeContent(
        onStart: () => _controller.nextPage(
          duration: kLongAnimationDuration,
          curve: Curves.easeOutCubic,
        ),
      ),
      const SetupAppearanceContent(),
      const SetupFinishContent(),
      if (isFree) const SetupProContent(),
    ];

    return BlocProvider(
      create: (_) => UserRelationshipBloc(handle: 'harpy_app'),
      child: HarpyScaffold(
        buildSafeArea: true,
        body: AnimatedPadding(
          duration: kShortAnimationDuration,
          padding: EdgeInsets.symmetric(vertical: config.paddingValue * 2),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: _enableScroll
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  children: children,
                ),
              ),
              SlideInAnimation(
                delay: const Duration(milliseconds: 3100),
                curve: Curves.easeOutCubic,
                offset: const Offset(0, 25),
                shouldHide: false,
                child: FadeAnimation(
                  delay: const Duration(milliseconds: 3100),
                  curve: Curves.easeOutCubic,
                  shouldHide: false,
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

class _SkipButton extends StatefulWidget {
  const _SkipButton({
    required this.controller,
  });

  final PageController controller;

  @override
  _SkipButtonState createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
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
      setState(() {
        _opacity = (1 - widget.controller.page!).clamp(0, 1);
      });
    }

    if (_opacity == 0) {
      // when the skip button is fully out of view once, hide it forever
      widget.controller.removeListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    if (_opacity == 0) {
      return const SizedBox();
    }

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        alignment: Alignment.centerLeft,
        child: HarpyButton.flat(
          padding: config.edgeInsets,
          text: const Text('skip'),
          onTap: finishSetup,
        ),
      ),
    );
  }
}

class _PrevButton extends StatefulWidget {
  const _PrevButton({
    required this.controller,
    required this.length,
  });

  final PageController controller;
  final int length;

  @override
  _PrevButtonState createState() => _PrevButtonState();
}

class _PrevButtonState extends State<_PrevButton> {
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
        _opacity = widget.controller.page!.clamp(0, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    if (_opacity == 0) {
      return const SizedBox();
    }

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        alignment: Alignment.centerLeft,
        child: HarpyButton.flat(
          padding: config.edgeInsets,
          icon: const Icon(CupertinoIcons.chevron_left),
          onTap: () => widget.controller.animateToPage(
            (widget.controller.page! - 1).round().clamp(0, widget.length - 1),
            duration: kLongAnimationDuration,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  const _NextButton({
    required this.controller,
    required this.length,
  });

  final PageController controller;
  final int length;

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
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
    final config = context.watch<ConfigCubit>().state;

    if (_opacity == 0) {
      return const SizedBox();
    }

    return Opacity(
      opacity: _opacity,
      child: Container(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        alignment: Alignment.centerRight,
        child: HarpyButton.flat(
          padding: config.edgeInsets,
          icon: const Icon(CupertinoIcons.chevron_right),
          onTap: () => widget.controller.animateToPage(
            (widget.controller.page! + 1).round().clamp(0, widget.length),
            duration: kLongAnimationDuration,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}

void finishSetup() {
  HapticFeedback.lightImpact();
  app<SetupPreferences>().performedSetup = true;
  app<HarpyNavigator>().pushReplacementNamed(HomeScreen.route);
}
