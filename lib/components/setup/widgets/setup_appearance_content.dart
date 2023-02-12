import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Builds the second page for the [SetupPage].
class SetupAppearanceContent extends StatelessWidget {
  const SetupAppearanceContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedPadding(
      duration: theme.animation.short,
      padding: theme.spacing.edgeInsets,
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
        Text('layout', style: theme.textTheme.headlineSmall),
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
    final display = ref.watch(displayPreferencesProvider);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final notifier = ref.watch(themePreferencesProvider.notifier);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    final predefinedThemes = ref.watch(predefinedThemesProvider);

    final materialYouLightData =
        ref.watch(materialYouLightProvider).asData?.value;
    final materialYouDarkData =
        ref.watch(materialYouDarkProvider).asData?.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'theme',
          style: theme.textTheme.headlineSmall,
        ),
        const _AnimatedVerticalSpacer(),
        if (materialYouLightData != null) ...[
          ThemeCard(
            HarpyTheme(
              data: materialYouLightData,
              fontSizeDelta: display.fontSizeDelta,
              displayFont: display.displayFont,
              bodyFont: display.bodyFont,
              compact: display.compactMode,
            ),
            selectedLightTheme: lightThemeId == -2,
            selectedDarkTheme: darkThemeId == -2,
            onTap: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId:
                  isFree || brightness == Brightness.light ? -2 : null,
              newDarkThemeId:
                  isFree || brightness == Brightness.dark ? -2 : null,
            ),
            onSelectLightTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId: -2,
            ),
            onSelectDarkTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newDarkThemeId: -2,
            ),
          ),
          const _AnimatedSmallVerticalSpacer(),
        ],
        if (materialYouDarkData != null) ...[
          ThemeCard(
            HarpyTheme(
              data: materialYouDarkData,
              fontSizeDelta: display.fontSizeDelta,
              displayFont: display.displayFont,
              bodyFont: display.bodyFont,
              compact: display.compactMode,
            ),
            selectedLightTheme: lightThemeId == -1,
            selectedDarkTheme: darkThemeId == -1,
            onTap: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId:
                  isFree || brightness == Brightness.light ? -1 : null,
              newDarkThemeId:
                  isFree || brightness == Brightness.dark ? -1 : null,
            ),
            onSelectLightTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newLightThemeId: -1,
            ),
            onSelectDarkTheme: () => selectTheme(
              themePreferences: themePreferences,
              themePreferencesNotifier: notifier,
              newDarkThemeId: -1,
            ),
          ),
          const _AnimatedSmallVerticalSpacer(),
        ],
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

class _AnimatedVerticalSpacer extends StatelessWidget {
  const _AnimatedVerticalSpacer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: theme.animation.short,
      height: theme.spacing.base,
    );
  }
}

class _AnimatedHorizontalSpacer extends StatelessWidget {
  const _AnimatedHorizontalSpacer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: theme.animation.short,
      width: theme.spacing.base,
    );
  }
}

class _AnimatedSmallVerticalSpacer extends StatelessWidget {
  const _AnimatedSmallVerticalSpacer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: theme.animation.short,
      height: theme.spacing.small,
    );
  }
}
