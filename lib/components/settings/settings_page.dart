import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage();

  static const name = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: 'settings'),
          SliverPadding(
            padding: padding,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _TweetSettingsCard(),
                verticalSpacer,
                _AppearanceSettingsCard(),
                verticalSpacer,
                _OtherSettingsCard(),
              ]),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _TweetSettingsCard extends ConsumerWidget {
  const _TweetSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('tweet'),
      children: [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.photo),
          title: const Text('media'),
          subtitle: const Text('settings for videos, images and gifs'),
          borderRadius: BorderRadius.only(
            bottomLeft: harpyTheme.radius,
            bottomRight: harpyTheme.radius,
          ),
          // onTap: () => app<HarpyNavigator>().pushNamed(
          //   MediaSettingsScreen.route,
          // ),
        ),
      ],
    );
  }
}

class _AppearanceSettingsCard extends ConsumerWidget {
  const _AppearanceSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('appearance'),
      children: [
        const HarpyListTile(
          leading: Icon(Icons.color_lens),
          title: Text('theme'),
          subtitle: Text('select your theme'),
          // onTap: () => app<HarpyNavigator>().pushNamed(
          //   ThemeSelectionScreen.route,
          // ),
        ),
        HarpyListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('display'),
          subtitle: const Text('change the look of the app'),
          borderRadius: BorderRadius.only(
            bottomLeft: harpyTheme.radius,
            bottomRight: harpyTheme.radius,
          ),
          // onTap: () => app<HarpyNavigator>().pushNamed(
          //   DisplaySettingsScreen.route,
          // ),
        ),
      ],
    );
  }
}

class _OtherSettingsCard extends ConsumerWidget {
  const _OtherSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('other'),
      children: [
        const HarpyListTile(
          leading: Icon(FeatherIcons.sliders),
          title: Text('general'),
          // onTap: () => app<HarpyNavigator>().pushNamed(
          //   GeneralSettingsScreen.route,
          // ),
        ),
        HarpyListTile(
          leading: const Icon(Icons.translate),
          title: const Text('language'),
          borderRadius: BorderRadius.only(
            bottomLeft: harpyTheme.radius,
            bottomRight: harpyTheme.radius,
          ),
          // onTap: () => app<HarpyNavigator>().pushNamed(
          //   LanguageSettingsScreen.route,
          // ),
        ),
      ],
    );
  }
}
