import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen();

  static const route = 'about';

  List<Widget> _buildTitleWithLogo(Color? textColor) {
    return [
      SizedBox(
        height: 100,
        child: FlareActor(
          'assets/flare/harpy_title.flr',
          animation: 'show',
          color: textColor,
        ),
      ),
      const SizedBox(
        height: 100,
        child: FlareActor(
          'assets/flare/harpy_logo.flr',
          animation: 'show',
        ),
      ),
    ];
  }

  Widget _buildIntroductionText(
    ThemeData theme,
    TextStyle linkStyle,
    bool isAuthenticated,
  ) {
    final version = app<HarpyInfo>().packageInfo!.version;

    return Card(
      child: Column(
        children: [
          HarpyListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
              style: theme.textTheme.subtitle1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: kRadius,
              topRight: kRadius,
            ),
            onTap: () => app<HarpyNavigator>().pushNamed(ChangelogScreen.route),
          ),
          HarpyListTile(
            leading: const Icon(FeatherIcons.github),
            title: const Text('harpy on GitHub'),
            subtitle: Text('github.com/robertodoering/harpy', style: linkStyle),
            onTap: () => launchUrl('https://github.com/robertodoering/harpy'),
          ),
          HarpyListTile(
            title: const Text('harpy on Twitter'),
            subtitle: Text(
              '@harpy_app',
              style: linkStyle,
            ),
            leading: const Icon(FeatherIcons.twitter),
            borderRadius: const BorderRadius.only(
              bottomLeft: kRadius,
              bottomRight: kRadius,
            ),
            onTap: isAuthenticated
                ? () => app<HarpyNavigator>().pushUserProfile(
                      handle: 'harpy_app',
                    )
                : () => launchUrl('https://twitter.com/harpy_app'),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationText(ThemeData theme, Config config) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: config.edgeInsets,
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
            borderRadius: const BorderRadius.only(
              bottomLeft: kRadius,
              bottomRight: kRadius,
            ),
            onTap: () => launchUrl(
              'https://paypal.com/paypalme/robertodoering',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProText(ThemeData theme, Config config, TextStyle linkStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: config.edgeInsets,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'support the development of harpy and get access '
                        'to a number of exclusive features by purchasing ',
                  ),
                  TextSpan(text: 'harpy pro', style: linkStyle),
                  const TextSpan(text: ' in the play store'),
                ],
              ),
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: FlareIcon.shiningStar(
              size: theme.iconTheme.size! + 8,
            ),
            leadingPadding: config.edgeInsets.copyWith(
              left: max(config.paddingValue - 4, 0),
              right: max(config.paddingValue - 4, 0),
              top: max(config.paddingValue - 4, 0),
              bottom: max(config.paddingValue - 4, 0),
            ),
            title: const Text('harpy pro'),
            borderRadius: const BorderRadius.only(
              bottomLeft: kRadius,
              bottomRight: kRadius,
            ),
            onTap: () => launchUrl(
              'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppText(ThemeData theme, Config config) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: config.edgeInsets,
            child: Text(
              'please rate harpy in the play store!',
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: FlareIcon.shiningStar(
              size: theme.iconTheme.size! + 8,
            ),
            leadingPadding: config.edgeInsets.copyWith(
              left: max(config.paddingValue - 4, 0),
              right: max(config.paddingValue - 4, 0),
              top: max(config.paddingValue - 4, 0),
              bottom: max(config.paddingValue - 4, 0),
            ),
            title: const Text('rate harpy'),
            subtitle: const Text('(coming soon)'),
            borderRadius: const BorderRadius.only(
              bottomLeft: kRadius,
              bottomRight: kRadius,
            ),
            onTap: () => app<MessageService>().show('coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperText(
    Config config,
    TextStyle linkStyle,
    TextTheme textTheme,
  ) {
    return HarpyListCard(
      leading: const Icon(FeatherIcons.mail),
      title: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'developed by '),
            TextSpan(text: 'roberto doering\n', style: linkStyle),
            TextSpan(text: 'rbydoering@gmail.com', style: linkStyle),
          ],
        ),
      ),
      subtitle: const Text('thank you for your feedback and bug reports!'),
      onTap: () => launchUrl('mailto:rbydoering+harpy@gmail.com?subject=Harpy'),
    );
  }

  Widget _buildPrivacyPolicy() {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.exclamationmark_shield),
      title: const Text('privacy policy'),
      onTap: () => launchUrl(
        'https://github.com/robertodoering/harpy/blob/master/PRIVACY.md',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final isAuthenticated =
        context.read<AuthenticationCubit>().state.isAuthenticated;

    final textTheme = theme.textTheme;
    final color = textTheme.bodyText2!.color;

    final linkStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return HarpyScaffold(
      title: 'about',
      actions: [
        CustomPopupMenuButton<void>(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onSelected: (_) => showLicensePage(context: context),
          itemBuilder: (_) => const [
            HarpyPopupMenuItem<int>(
              value: 0,
              text: Text('show licenses'),
            ),
          ],
        ),
      ],
      body: ListView(
        padding: config.edgeInsets,
        children: [
          ..._buildTitleWithLogo(color),
          verticalSpacer,
          _buildIntroductionText(theme, linkStyle, isAuthenticated),
          verticalSpacer,
          _buildDonationText(theme, config),
          if (isFree) ...[
            verticalSpacer,
            _buildProText(theme, config, linkStyle),
          ],
          verticalSpacer,
          _buildRateAppText(theme, config),
          verticalSpacer,
          _buildDeveloperText(config, linkStyle, textTheme),
          verticalSpacer,
          _buildPrivacyPolicy(),
          SizedBox(height: mediaQuery.padding.bottom),
        ],
      ),
    );
  }
}
