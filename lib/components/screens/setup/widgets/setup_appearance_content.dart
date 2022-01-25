import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds the second page for the [SetupScreen].
class SetupAppearanceContent extends StatelessWidget {
  const SetupAppearanceContent();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return AnimatedPadding(
      duration: kShortAnimationDuration,
      padding: config.edgeInsets,
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PreviewTweetCard(
            text: 'Thank you for using harpy!',
          ),
          _AnimatedVerticalSpacer(),
          _AnimatedVerticalSpacer(),
          _Layout(),
          _AnimatedVerticalSpacer(),
          _AnimatedVerticalSpacer(),
          _Theme(),
        ],
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final configCubit = context.watch<ConfigCubit>();
    final config = configCubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'layout',
          style: theme.textTheme.headline5,
        ),
        const _AnimatedVerticalSpacer(),
        Row(
          children: [
            Expanded(
              child: SetupListCard(
                text: 'fancy',
                selected: !config.compactMode,
                onTap: () {
                  HapticFeedback.lightImpact();

                  configCubit.updateCompactMode(false);
                },
              ),
            ),
            const _AnimatedHorizontalSpacer(),
            Expanded(
              child: SetupListCard(
                text: 'compact',
                selected: config.compactMode,
                onTap: () {
                  HapticFeedback.lightImpact();

                  configCubit.updateCompactMode(true);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Theme extends StatelessWidget {
  const _Theme();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemBrightness = context.watch<Brightness>();
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ThemeBloc>();

    final lightThemeId = app<ThemePreferences>().lightThemeId;
    final darkThemeId = app<ThemePreferences>().darkThemeId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'theme',
          style: theme.textTheme.headline5,
        ),
        const _AnimatedVerticalSpacer(),
        for (var i = 0; i < predefinedThemes.length; i++) ...[
          ThemeCard(
            HarpyTheme.fromData(data: predefinedThemes[i], config: config),
            selectedLightTheme: i == lightThemeId,
            selectedDarkTheme: i == darkThemeId,
            onTap: () => selectTheme(
              themeBloc: bloc,
              lightThemeId: lightThemeId,
              darkThemeId: darkThemeId,
              newLightThemeId:
                  isFree || systemBrightness == Brightness.light ? i : null,
              newDarkThemeId:
                  isFree || systemBrightness == Brightness.dark ? i : null,
            ),
            onSelectLightTheme: () => selectTheme(
              themeBloc: bloc,
              lightThemeId: lightThemeId,
              darkThemeId: darkThemeId,
              newLightThemeId: i,
            ),
            onSelectDarkTheme: () => selectTheme(
              themeBloc: bloc,
              lightThemeId: lightThemeId,
              darkThemeId: darkThemeId,
              newDarkThemeId: i,
            ),
          ),
          if (i < predefinedThemes.length - 1)
            const _AnimatedSmallVerticalSpacer(),
        ],
      ],
    );
  }
}

class _AnimatedVerticalSpacer extends StatelessWidget {
  const _AnimatedVerticalSpacer();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      height: config.paddingValue,
    );
  }
}

class _AnimatedHorizontalSpacer extends StatelessWidget {
  const _AnimatedHorizontalSpacer();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      width: config.paddingValue,
    );
  }
}

class _AnimatedSmallVerticalSpacer extends StatelessWidget {
  const _AnimatedSmallVerticalSpacer();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      height: config.smallPaddingValue,
    );
  }
}
