import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Builds the second page for the [SetupPage].
class SetupAppearanceContent extends ConsumerWidget {
  const SetupAppearanceContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedPadding(
      duration: kShortAnimationDuration,
      padding: display.edgeInsets,
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PreviewTweetCard(text: 'Thank you for using harpy!'),
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

class _Layout extends ConsumerWidget {
  const _Layout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final display = ref.watch(displayPreferencesProvider);
    final notifier = ref.watch(displayPreferencesProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('layout', style: theme.textTheme.headline5),
        const _AnimatedVerticalSpacer(),
        Row(
          children: [
            Expanded(
              child: SetupListCard(
                text: 'fancy',
                selected: !display.compactMode,
                onTap: () {
                  HapticFeedback.lightImpact();
                  notifier.setCompactMode(false);
                },
              ),
            ),
            const _AnimatedHorizontalSpacer(),
            Expanded(
              child: SetupListCard(
                text: 'compact',
                selected: display.compactMode,
                onTap: () {
                  HapticFeedback.lightImpact();
                  notifier.setCompactMode(true);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Theme extends ConsumerWidget {
  const _Theme();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final notifier = ref.watch(themePreferencesProvider.notifier);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    final predefinedThemes = ref.watch(predefinedThemesProvider);

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
            predefinedThemes[i],
            selectedLightTheme: i == lightThemeId,
            selectedDarkTheme: i == darkThemeId,
            onTap: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId:
                  isFree || brightness == Brightness.light ? i : null,
              newDarkThemeId:
                  isFree || brightness == Brightness.dark ? i : null,
            ),
            onSelectLightTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId: i,
            ),
            onSelectDarkTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
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

class _AnimatedVerticalSpacer extends ConsumerWidget {
  const _AnimatedVerticalSpacer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      height: display.paddingValue,
    );
  }
}

class _AnimatedHorizontalSpacer extends ConsumerWidget {
  const _AnimatedHorizontalSpacer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      width: display.paddingValue,
    );
  }
}

class _AnimatedSmallVerticalSpacer extends ConsumerWidget {
  const _AnimatedSmallVerticalSpacer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedContainer(
      duration: kShortAnimationDuration,
      height: display.smallPaddingValue,
    );
  }
}
