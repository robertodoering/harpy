import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class CustomThemePage extends ConsumerStatefulWidget {
  const CustomThemePage({
    required this.themeId,
  });

  /// The id of the custom theme when editing an existing custom theme.
  final int? themeId;

  static const name = 'custom_theme';

  @override
  ConsumerState<CustomThemePage> createState() => _CustomThemePageState();
}

class _CustomThemePageState extends ConsumerState<CustomThemePage> {
  Key _scopeKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final customThemeData = ref.watch(customThemeProvider(widget.themeId));
    final notifier = ref.watch(customThemeProvider(widget.themeId).notifier);

    ref.listen(customThemeProvider(widget.themeId), (_, __) {
      // workaround to rebuild the provider scope with the new customThemeData
      if (mounted) setState(() => _scopeKey = UniqueKey());
    });

    final harpyTheme = HarpyTheme(
      data: customThemeData,
      fontSizeDelta: display.fontSizeDelta,
      displayFont: display.displayFont,
      bodyFont: display.bodyFont,
      compact: display.compactMode,
    );

    return ProviderScope(
      key: _scopeKey,
      overrides: [
        harpyThemeProvider.overrideWith((ref) => harpyTheme),
      ],
      child: Theme(
        data: harpyTheme.themeData,
        child: AnnotatedRegion(
          value: harpyTheme.colors.systemUiOverlayStyle,
          child: _WillPopCustomTheme(
            notifier: notifier,
            child: HarpyScaffold(
              child: CustomScrollView(
                slivers: [
                  HarpySliverAppBar(
                    title: const Text('custom theme'),
                    actions: [
                      _SaveThemeAction(
                        themeId: widget.themeId,
                        notifier: notifier,
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: theme.spacing.edgeInsets,
                    sliver: _CustomThemeList(notifier: notifier),
                  ),
                  const SliverBottomPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomThemeList extends ConsumerWidget {
  const _CustomThemeList({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        if (isFree) ...const [
          CustomThemeProCard(),
          VerticalSpacer.normal,
        ],
        CustomThemeName(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemePrimaryColor(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemeSecondaryColor(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemeCardColor(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemeStatusBarColor(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemeNavBarColor(notifier: notifier),
        VerticalSpacer.normal,
        CustomThemeBackgroundColors(notifier: notifier),
      ]),
    );
  }
}

class _WillPopCustomTheme extends StatelessWidget {
  const _WillPopCustomTheme({
    required this.child,
    required this.notifier,
  });

  final Widget child;
  final CustomThemeNotifier notifier;

  Future<bool> _onWillPop(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (notifier.modified) {
      // ask to discard changes before exiting customization
      final discard = await showDialog<bool>(
        context: context,
        builder: (_) => RbyDialog(
          title: const Text('discard changes?'),
          actions: [
            RbyButton.text(
              label: const Text('cancel'),
              onTap: Navigator.of(context).pop,
            ),
            RbyButton.text(
              label: const Text('discard'),
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      return discard ?? false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: child,
    );
  }
}

class _SaveThemeAction extends ConsumerWidget {
  const _SaveThemeAction({
    required this.themeId,
    required this.notifier,
  });

  final int? themeId;
  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final brightness = ref.watch(platformBrightnessProvider);
    final themePreferences = ref.watch(themePreferencesProvider);
    final themePreferencesNotifier =
        ref.watch(themePreferencesProvider.notifier);

    final lightThemeId = themePreferences.lightThemeId;
    final darkThemeId = themePreferences.darkThemeId;

    return RbyButton.transparent(
      icon: const Icon(FeatherIcons.check),
      onTap: notifier.canSaveTheme
          ? () {
              themePreferencesNotifier.addCustomTheme(
                themeData: harpyTheme.data,
                themeId: themeId,
                updateLightThemeSelection: brightness == Brightness.light ||
                    lightThemeId == darkThemeId,
                updateDarkThemeSelection: brightness == Brightness.dark ||
                    lightThemeId == darkThemeId,
              );

              Navigator.of(context).pop();
            }
          : null,
    );
  }
}
