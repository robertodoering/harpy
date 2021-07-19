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

  static const String route = 'about';

  static const String mailto =
      'mailto:rbydoering+harpy@gmail.com?subject=Harpy';

  static const String _privacyPolicy =
      'https://developer.twitter.com/en/developer-terms/policy';

  List<Widget> _buildTitleWithLogo(Color? textColor) {
    return <Widget>[
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

  Widget _buildIntroductionText(ThemeData theme, TextStyle linkStyle) {
    final version = app<HarpyInfo>().packageInfo!.version;

    return Card(
      child: Column(
        children: <Widget>[
          HarpyListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
              style: theme.textTheme.subtitle1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: kDefaultRadius,
              topRight: kDefaultRadius,
            ),
            onTap: () => app<HarpyNavigator>().pushNamed(ChangelogScreen.route),
          ),
          HarpyListTile(
            leading: const Icon(FeatherIcons.github),
            title: const Text('harpy is open source'),
            subtitle: Text('github.com/robertodoering/harpy', style: linkStyle),
            borderRadius: const BorderRadius.only(
              bottomLeft: kDefaultRadius,
              bottomRight: kDefaultRadius,
            ),
            onTap: () => launchUrl('https://github.com/robertodoering/harpy'),
          ),
        ],
      ),
    );
  }

  Widget _buildProText(ThemeData theme, Config config, TextStyle linkStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: config.edgeInsets,
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
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
            leading: const FlareIcon.shiningStar(
              size: 28,
              offset: Offset(-4, 0),
            ),
            title: const Text('harpy pro'),
            borderRadius: const BorderRadius.only(
              bottomLeft: kDefaultRadius,
              bottomRight: kDefaultRadius,
            ),
            onTap: () => app<MessageService>().show('coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppText(ThemeData theme, Config config) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: config.edgeInsets,
            child: Text(
              'please rate harpy in the play store!',
              style: theme.textTheme.subtitle2,
            ),
          ),
          HarpyListTile(
            leading: const FlareIcon.shiningStar(
              size: 28,
              offset: Offset(-4, 0),
            ),
            title: const Text('rate harpy'),
            borderRadius: const BorderRadius.only(
              bottomLeft: kDefaultRadius,
              bottomRight: kDefaultRadius,
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
          children: <InlineSpan>[
            const TextSpan(text: 'developed by '),
            TextSpan(text: 'roberto doering\n', style: linkStyle),
            TextSpan(text: 'rbydoering@gmail.com', style: linkStyle),
          ],
        ),
      ),
      subtitle: const Text(
        'thank you for your feedback and bug reports asdasdsadsa!',
      ),
      onTap: () => launchUrl(mailto),
    );
  }

  Widget _buildPrivacyPolicy() {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.exclamationmark_shield),
      title: const Text('privacy policy'),
      onTap: () => launchUrl(_privacyPolicy),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final textTheme = theme.textTheme;
    final color = textTheme.bodyText2!.color;

    final linkStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return HarpyScaffold(
      title: 'about',
      actions: <Widget>[
        CustomPopupMenuButton<void>(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onSelected: (_) => showLicensePage(context: context),
          itemBuilder: (context) {
            return <PopupMenuEntry<int>>[
              const HarpyPopupMenuItem<int>(
                value: 0,
                text: Text('show licenses'),
              ),
            ];
          },
        ),
      ],
      body: ListView(
        padding: config.edgeInsets,
        children: <Widget>[
          ..._buildTitleWithLogo(color),
          defaultVerticalSpacer,
          _buildIntroductionText(theme, linkStyle),
          if (Harpy.isFree) ...<Widget>[
            defaultVerticalSpacer,
            _buildProText(theme, config, linkStyle),
          ],
          defaultVerticalSpacer,
          _buildRateAppText(theme, config),
          defaultVerticalSpacer,
          _buildDeveloperText(config, linkStyle, textTheme),
          defaultVerticalSpacer,
          _buildPrivacyPolicy(),
          SizedBox(height: mediaQuery.padding.bottom),
        ],
      ),
    );
  }
}
