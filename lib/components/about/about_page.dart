import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class AboutPage extends StatelessWidget {
  const AboutPage();

  static const name = 'about';
  static const path = '/about_harpy';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('about'),
            actions: [
              RbyPopupMenuButton(
                onSelected: (_) => showLicensePage(context: context),
                itemBuilder: (_) => const [
                  RbyPopupMenuListTile(
                    value: true,
                    title: Text('licenses'),
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _HarpyLogo(),
                VerticalSpacer.normal,
                _SummaryCard(),
                VerticalSpacer.normal,
                _DonationCard(),
                VerticalSpacer.normal,
                if (isFree) ...[
                  _ProCard(),
                  VerticalSpacer.normal,
                ],
                _CreditsCard(),
                VerticalSpacer.normal,
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
    final version = ref.watch(deviceInfoProvider).packageInfo?.version;
    final launcher = ref.watch(launcherProvider);

    final isAuthenticated =
        ref.watch(authenticationStateProvider).isAuthenticated;

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      child: Column(
        children: [
          RbyListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
              style: theme.textTheme.titleMedium,
            ),
            borderRadius: BorderRadius.only(
              topLeft: theme.shape.radius,
              topRight: theme.shape.radius,
            ),
            onTap: () => context.pushNamed(ChangelogPage.name),
          ),
          RbyListTile(
            leading: const Icon(FeatherIcons.github),
            title: const Text('harpy on GitHub'),
            subtitle: Text('github.com/robertodoering/harpy', style: style),
            onTap: () => launcher('https://github.com/robertodoering/harpy'),
          ),
          RbyListTile(
            title: const Text('harpy on Twitter'),
            subtitle: Text('@harpy_app', style: style),
            leading: const Icon(FeatherIcons.twitter),
            borderRadius: BorderRadius.only(
              bottomLeft: theme.shape.radius,
              bottomRight: theme.shape.radius,
            ),
            onTap: isAuthenticated
                ? () => context.pushNamed(
                      UserPage.name,
                      params: {'handle': 'harpy_app'},
                    )
                : () => launcher('https://twitter.com/harpy_app'),
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
    final launcher = ref.watch(launcherProvider);

    return Card(
      child: Column(
        children: [
          Padding(
            padding: theme.spacing.edgeInsets,
            child: Text(
              'if you like harpy, please consider supporting the '
              'development with a donation',
              style: theme.textTheme.titleSmall,
            ),
          ),
          RbyListTile(
            leading: const Icon(FeatherIcons.coffee),
            title: const Text('buy me a coffee'),
            onTap: () => launcher('https://ko-fi.com/robertodoering'),
          ),
          RbyListTile(
            leading: const Icon(FeatherIcons.dollarSign),
            title: const Text('donate via PayPal'),
            borderRadius: BorderRadius.only(
              bottomLeft: theme.shape.radius,
              bottomRight: theme.shape.radius,
            ),
            onTap: () => launcher(
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
    final launcher = ref.watch(launcherProvider);

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: theme.spacing.edgeInsets,
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
              style: theme.textTheme.titleSmall,
            ),
          ),
          RbyListTile(
            leading: const FlareIcon.shiningStar(),
            title: const Text('harpy pro'),
            borderRadius: BorderRadius.only(
              bottomLeft: theme.shape.radius,
              bottomRight: theme.shape.radius,
            ),
            onTap: () => launcher(
              'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsCard extends ConsumerWidget {
  const _CreditsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcher = ref.watch(launcherProvider);
    final theme = Theme.of(context);

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return RbyListCard(
      leading: const Icon(FeatherIcons.mail),
      multilineTitle: true,
      title: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'developed by '),
            TextSpan(text: 'roberto doering\n', style: style),
            TextSpan(text: 'support@harpyapp.com', style: style),
          ],
        ),
      ),
      subtitle: const Text('thank you for your feedback and bug reports!'),
      onTap: () => launcher(
        'mailto:support@harpyapp.com?'
        'subject=${isPro ? "harpy pro" : "harpy"}',
        alwaysOpenExternally: true,
      ),
    );
  }
}

class _PrivacyPolicyCard extends ConsumerWidget {
  const _PrivacyPolicyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcher = ref.watch(launcherProvider);

    return RbyListCard(
      leading: const Icon(CupertinoIcons.exclamationmark_shield),
      title: const Text('privacy policy'),
      onTap: () => launcher(
        'https://github.com/robertodoering/harpy/blob/master/PRIVACY.md',
      ),
    );
  }
}
