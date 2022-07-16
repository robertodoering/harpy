import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage();

  static const name = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('settings')),
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
    final router = ref.watch(routerProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('tweet'),
      children: [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.photo),
          title: const Text('media'),
          subtitle: const Text('settings for tweet videos, images and gifs'),
          borderRadius: BorderRadius.only(
            bottomLeft: harpyTheme.radius,
            bottomRight: harpyTheme.radius,
          ),
          onTap: () => router.goNamed(MediaSettingsPage.name),
        ),
      ],
    );
  }
}

class _AppearanceSettingsCard extends ConsumerWidget {
  const _AppearanceSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('appearance'),
      children: [
        HarpyListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('theme'),
          subtitle: const Text('select your theme'),
          onTap: () => router.goNamed(ThemeSettingsPage.name),
        ),
        HarpyListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('display'),
          subtitle: const Text('change the look of harpy'),
          borderRadius: BorderRadius.only(
            bottomLeft: harpyTheme.radius,
            bottomRight: harpyTheme.radius,
          ),
          onTap: () => router.goNamed(DisplaySettingsPage.name),
        ),
      ],
    );
  }
}

class _OtherSettingsCard extends ConsumerWidget {
  const _OtherSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final hasUnapprovedDomains =
        ref.watch(hasUnapprovedDomainsProvider).maybeWhen(
              data: (data) => data,
              orElse: () => false,
            );

    return ExpansionCard(
      title: const Text('other'),
      children: [
        HarpyListTile(
          leading: const Icon(FeatherIcons.sliders),
          title: const Text('general'),
          onTap: () => router.goNamed(GeneralSettingsPage.name),
        ),
        HarpyListTile(
          leading: const Icon(Icons.translate),
          title: const Text('language'),
          borderRadius: hasUnapprovedDomains
              ? null
              : BorderRadius.only(
                  bottomLeft: harpyTheme.radius,
                  bottomRight: harpyTheme.radius,
                ),
          onTap: () => router.goNamed(LanguageSettingsPage.name),
        ),
        if (hasUnapprovedDomains)
          HarpyListTile(
            leading: const Icon(CupertinoIcons.share),
            title: const Text('open twitter links'),
            subtitle: const Text('allow harpy to open twitter links'),
            borderRadius: BorderRadius.only(
              bottomLeft: harpyTheme.radius,
              bottomRight: harpyTheme.radius,
            ),
            onTap: showOpenByDefault,
          ),
      ],
    );
  }
}
