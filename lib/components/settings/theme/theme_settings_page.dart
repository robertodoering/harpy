import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage();

  static const name = 'theme_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(title: Text('theme')),
          _MaterialYouThemes(),
          _PredefinedThemes(),
          if (isPro) _CustomThemes(),
          SliverToBoxAdapter(child: smallVerticalSpacer),
          SliverToBoxAdapter(child: CreateCustomThemeCard()),
          if (isFree) _LockedProThemes(),
          SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _MaterialYouThemes extends ConsumerWidget {
  const _MaterialYouThemes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final notifier = ref.watch(themePreferencesProvider.notifier);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    final materialYouLight = ref.watch(materialYouLightProvider);
    final materialYouDark = ref.watch(materialYouDarkProvider);
    final lightData = materialYouLight.asData?.value;
    final darkData = materialYouDark.asData?.value;

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          if (lightData != null) ...[
            ThemeCard(
              HarpyTheme(
                data: lightData,
                fontSizeDelta: display.fontSizeDelta,
                displayFont: display.displayFont,
                bodyFont: display.bodyFont,
                paddingValue: display.paddingValue,
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
            smallVerticalSpacer,
          ],
          if (darkData != null) ...[
            ThemeCard(
              HarpyTheme(
                data: darkData,
                fontSizeDelta: display.fontSizeDelta,
                displayFont: display.displayFont,
                bodyFont: display.bodyFont,
                paddingValue: display.paddingValue,
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
            smallVerticalSpacer,
          ],
        ]),
      ),
    );
  }
}

class _PredefinedThemes extends ConsumerWidget {
  const _PredefinedThemes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final notifier = ref.watch(themePreferencesProvider.notifier);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    final predefinedThemes = ref.watch(predefinedThemesProvider);

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
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
            if (i != predefinedThemes.length - 1) smallVerticalSpacer,
          ],
        ]),
      ),
    );
  }
}

class _CustomThemes extends ConsumerWidget {
  const _CustomThemes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final display = ref.watch(displayPreferencesProvider);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final notifier = ref.watch(themePreferencesProvider.notifier);
    final customThemes = ref.watch(customHarpyThemesProvider);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        if (customThemes.isNotEmpty) Divider(height: display.paddingValue * 2),
        for (var i = 0; i < customThemes.length; i++) ...[
          Padding(
            padding: display.edgeInsetsSymmetric(horizontal: true),
            child: ThemeCard(
              HarpyTheme(
                data: customThemes[i],
                fontSizeDelta: display.fontSizeDelta,
                displayFont: display.displayFont,
                bodyFont: display.bodyFont,
                paddingValue: display.paddingValue,
              ),
              selectedLightTheme: i + 10 == lightThemeId,
              selectedDarkTheme: i + 10 == darkThemeId,
              onTap: () => lightThemeId == i + 10 || darkThemeId == i + 10
                  // edit selected theme
                  ? router.goNamed(
                      CustomThemePage.name,
                      queryParams: {'themeId': '${i + 10}'},
                    )
                  // select theme
                  : selectTheme(
                      themePreferences: themePreferences,
                      themePreferencesNotifier: notifier,
                      newLightThemeId:
                          brightness == Brightness.light ? i + 10 : null,
                      newDarkThemeId:
                          brightness == Brightness.dark ? i + 10 : null,
                    ),
              onSelectLightTheme: () => selectTheme(
                themePreferences: themePreferences,
                themePreferencesNotifier: notifier,
                newLightThemeId: i + 10,
              ),
              onSelectDarkTheme: () => selectTheme(
                themePreferences: themePreferences,
                themePreferencesNotifier: notifier,
                newDarkThemeId: i + 10,
              ),
              onEdit: () => router.goNamed(
                CustomThemePage.name,
                queryParams: {'themeId': '${i + 10}'},
              ),
              onDelete: () => notifier.removeCustomTheme(
                themeId: i + 10,
              ),
            ),
          ),
          if (i < customThemes.length - 1) smallVerticalSpacer,
        ],
      ]),
    );
  }
}

class _LockedProThemes extends ConsumerWidget {
  const _LockedProThemes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final predefinedProThemes = ref.watch(predefinedProThemesProvider);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Divider(height: display.paddingValue * 2),
        Padding(
          padding: display.edgeInsetsSymmetric(horizontal: true),
          child: Text(
            'only available for harpy pro',
            style: theme.textTheme.subtitle2?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(.8),
            ),
          ),
        ),
        verticalSpacer,
        for (final theme in predefinedProThemes) ...[
          Padding(
            padding: display.edgeInsetsSymmetric(horizontal: true),
            child: LockedProThemeCard(theme),
          ),
          smallVerticalSpacer,
        ]
      ]),
    );
  }
}

void selectTheme({
  required ThemePreferences themePreferences,
  required ThemePreferencesNotifier themePreferencesNotifier,
  int? newLightThemeId,
  int? newDarkThemeId,
}) {
  assert(
    isPro || newLightThemeId == newDarkThemeId,
    "can't select light & dark theme independently in the free version",
  );

  if (themePreferences.lightThemeId != newLightThemeId ||
      themePreferences.darkThemeId != newDarkThemeId) {
    HapticFeedback.lightImpact();

    themePreferencesNotifier.setThemeId(
      lightThemeId: newLightThemeId,
      darkThemeId: newDarkThemeId,
    );
  }
}
