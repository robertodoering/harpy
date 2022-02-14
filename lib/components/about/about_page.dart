import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage();

  static const name = 'about';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: 'about'),
          SliverPadding(
            padding: padding,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _HarpyLogo(),
                verticalSpacer,
                _SummaryCard(),
                verticalSpacer,
                _DonationCard(),
                verticalSpacer,
                _ProCard(),
                verticalSpacer,
                _RateAppCard(),
                verticalSpacer,
                _CreditsCard(),
                verticalSpacer,
                _PrivacyPolicyCard(),
              ]),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _HarpyLogo extends StatelessWidget {
  const _HarpyLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 100,
          child: FlareAnimation.harpyTitle(
            animation: 'show',
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(
          height: 100,
          child: FlareAnimation.harpyLogo(animation: 'show'),
        ),
      ],
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final router = ref.watch(routerProvider);
    final version = ref.watch(deviceInfoProvider).packageInfo?.version;

    final isAuthenticated =
        ref.watch(authenticationStateProvider).isAuthenticated;

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      child: Column(
        children: [
          HarpyListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
              style: theme.textTheme.subtitle1,
            ),
            borderRadius: BorderRadius.only(
              topLeft: harpyTheme.radius,
              topRight: harpyTheme.radius,
            ),
            onTap: () => router.goNamed(ChangelogPage.name),
          ),
          HarpyListTile(
            leading: const Icon(FeatherIcons.github),
            title: const Text('harpy on GitHub'),
            subtitle: Text('github.com/robertodoering/harpy', style: style),
            onTap: () => launchUrl('https://github.com/robertodoering/harpy'),
          ),
          HarpyListTile(
            title: const Text('harpy on Twitter'),
            subtitle: Text('@harpy_app', style: style),
            leading: const Icon(FeatherIcons.twitter),
            borderRadius: BorderRadius.only(
              bottomLeft: harpyTheme.radius,
              bottomRight: harpyTheme.radius,
            ),
            onTap: isAuthenticated
                ? () => router.goNamed(UserPage.name) // handle: 'harpy_app'
                : () => launchUrl('https://twitter.com/harpy_app'),
          ),
        ],
      ),
    );
  }
}

class _DonationCard extends ConsumerWidget {
  const _DonationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final padding = ref.watch(displayPreferencesProvider).edgeInsets;

    return Card(
      child: Column(
        children: [
          Padding(
            padding: padding,
            child: Text(
              'if you like harpy, please consider supporting the '
              'development with a donation',
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: const Icon(FeatherIcons.coffee),
            title: const Text('buy me a coffee'),
            onTap: () => launchUrl('https://ko-fi.com/robertodoering'),
          ),
          HarpyListTile(
            leading: const Icon(FeatherIcons.dollarSign),
            title: const Text('donate via PayPal'),
            borderRadius: BorderRadius.only(
              bottomLeft: harpyTheme.radius,
              bottomRight: harpyTheme.radius,
            ),
            onTap: () => launchUrl(
              'https://paypal.com/paypalme/robertodoering',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProCard extends ConsumerWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: display.edgeInsets,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'support the development of harpy and get access '
                        'to a number of exclusive features by purchasing ',
                  ),
                  TextSpan(text: 'harpy pro', style: style),
                  const TextSpan(text: ' in the play store'),
                ],
              ),
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: const FlareIcon.shiningStar(),
            title: const Text('harpy pro'),
            borderRadius: BorderRadius.only(
              bottomLeft: harpyTheme.radius,
              bottomRight: harpyTheme.radius,
            ),
            onTap: () => launchUrl(
              'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
            ),
          ),
        ],
      ),
    );
  }
}

class _RateAppCard extends ConsumerWidget {
  const _RateAppCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: display.edgeInsets,
            child: Text(
              'please rate harpy in the play store!',
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: const FlareIcon.shiningStar(),
            title: const Text('rate harpy'),
            subtitle: const Text('(coming soon)'),
            borderRadius: BorderRadius.only(
              bottomLeft: harpyTheme.radius,
              bottomRight: harpyTheme.radius,
            ),
            onTap: () => ref.read(messageServiceProvider).showText(
                  'coming soon!',
                ),
          ),
        ],
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return HarpyListCard(
      leading: const Icon(FeatherIcons.mail),
      title: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'developed by '),
            TextSpan(text: 'roberto doering\n', style: style),
            TextSpan(text: 'rbydoering@gmail.com', style: style),
          ],
        ),
      ),
      subtitle: const Text('thank you for your feedback and bug reports!'),
      onTap: () => launchUrl('mailto:rbydoering+harpy@gmail.com?subject=Harpy'),
    );
  }
}

class _PrivacyPolicyCard extends StatelessWidget {
  const _PrivacyPolicyCard();

  @override
  Widget build(BuildContext context) {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.exclamationmark_shield),
      title: const Text('privacy policy'),
      onTap: () => launchUrl(
        'https://github.com/robertodoering/harpy/blob/master/PRIVACY.md',
      ),
    );
  }
}
