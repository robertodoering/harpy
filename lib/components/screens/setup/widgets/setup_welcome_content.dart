import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the first page for the [SetupScreen].
class SetupWelcomeContent extends StatefulWidget {
  const SetupWelcomeContent({
    required this.onStart,
  });

  final VoidCallback onStart;

  @override
  State<SetupWelcomeContent> createState() => _SetupWelcomeContentState();
}

class _SetupWelcomeContentState extends State<SetupWelcomeContent>
    with AutomaticKeepAliveClientMixin {
  // keep state even when scrolling off-screen in the page view
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.paddingValue * 2),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideInAnimation(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  offset: const Offset(0, 50),
                  shouldHide: false,
                  child: FadeAnimation(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    shouldHide: false,
                    child: Text(
                      'welcome',
                      style: theme.textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                verticalSpacer,
                verticalSpacer,
                SlideInAnimation(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.easeOutCubic,
                  offset: const Offset(0, 50),
                  shouldHide: false,
                  child: FadeAnimation(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 1600),
                    curve: Curves.easeOutCubic,
                    shouldHide: false,
                    child: FittedBox(
                      child: Text(
                        authCubit.state.user!.name,
                        style: theme.textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpacer,
          SlideInAnimation(
            delay: const Duration(milliseconds: 2400),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            offset: const Offset(0, 25),
            shouldHide: false,
            child: FadeAnimation(
              delay: const Duration(milliseconds: 2400),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              shouldHide: false,
              child: Text(
                "let's take a moment to setup your experience",
                style: theme.textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          verticalSpacer,
          Expanded(
            child: BounceInAnimation(
              delay: const Duration(milliseconds: 2800),
              child: HarpyButton.custom(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'start',
                      style: theme.textTheme.headline6!.copyWith(height: 1),
                      maxLines: 1,
                    ),
                    smallHorizontalSpacer,
                    const Icon(CupertinoIcons.chevron_right),
                  ],
                ),
                onTap: widget.onStart,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
