import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage();

  static const name = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('settings')),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _TweetSettingsCard(),
                VerticalSpacer.normal,
                _AppearanceSettingsCard(),
                VerticalSpacer.normal,
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
    final theme = Theme.of(context);

    return ExpansionCard(
      title: const Text('tweet'),
      children: [
        RbyListTile(
          leading: const Icon(CupertinoIcons.photo),
          title: const Text('media'),
          subtitle: const Text('settings for tweet videos, images and gifs'),
          borderRadius: BorderRadius.only(
            bottomLeft: theme.shape.radius,
            bottomRight: theme.shape.radius,
          ),
          onTap: () => context.goNamed(MediaSettingsPage.name),
        ),
      ],
    );
  }
}

class _AppearanceSettingsCard extends ConsumerWidget {
  const _AppearanceSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ExpansionCard(
      title: const Text('appearance'),
      children: [
        RbyListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('theme'),
          subtitle: const Text('select your theme'),
          onTap: () => context.goNamed(ThemeSettingsPage.name),
        ),
        RbyListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('display'),
          subtitle: const Text('change the look of harpy'),
          borderRadius: BorderRadius.only(
            bottomLeft: theme.shape.radius,
            bottomRight: theme.shape.radius,
          ),
          onTap: () => context.goNamed(DisplaySettingsPage.name),
        ),
      ],
    );
  }
}

class _OtherSettingsCard extends ConsumerWidget {
  const _OtherSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnapprovedDomains =
        ref.watch(hasUnapprovedDomainsProvider).maybeWhen(
              data: (data) => data,
              orElse: () => false,
            );

    final usingCustomApi =
        ref.watch(customApiPreferencesProvider).hasCustomApiKeyAndSecret;

    return ExpansionCard(
      title: const Text('other'),
      children: [
        RbyListTile(
          leading: const Icon(FeatherIcons.sliders),
          title: const Text('general'),
          onTap: () => context.goNamed(GeneralSettingsPage.name),
        ),
        RbyListTile(
          leading: const Icon(Icons.translate),
          title: const Text('language'),
          onTap: () => context.goNamed(LanguageSettingsPage.name),
        ),
        if (hasUnapprovedDomains)
          const RbyListTile(
            leading: Icon(CupertinoIcons.share),
            title: Text('open Twitter links'),
            subtitle: Text('allow harpy to open Twitter links'),
            onTap: showOpenByDefault,
          ),
        if (!usingCustomApi)
          RbyListTile(
            leading: const Icon(FeatherIcons.twitter),
            title: const Text('use custom api key'),
            subtitle: const Text(
              'connect to Twitter with your own api credentials',
            ),
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => const CustomApiDialog(),
              );

              if (result ?? false) {
                ref
                    .read(logoutProvider)
                    .logout(target: CustomApiPage.name)
                    .ignore();
              }
            },
          ),
      ],
    );
  }
}
