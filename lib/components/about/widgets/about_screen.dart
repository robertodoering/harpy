import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/changelog/widgets/changelog_screen.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/url_launcher.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen();

  static const String route = 'about';

  static const String mailto =
      'mailto:rbydoering+harpy@gmail.com?subject=Harpy';

  static const String _privacyPolicy =
      'https://developer.twitter.com/en/developer-terms/policy';

  List<Widget> _buildTitleWithLogo(Color textColor) {
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

  Widget _buildVersionCode(ThemeData theme) {
    final String version = app<HarpyInfo>().packageInfo.version;

    return Center(
      child: Text('Version $version', style: theme.textTheme.subtitle2),
    );
  }

  Widget _buildIntroductionText(ThemeData theme, TextStyle linkStyle) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'Version history',
              style: theme.textTheme.subtitle1,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: kDefaultRadius,
                topRight: kDefaultRadius,
              ),
            ),
            onTap: () => app<HarpyNavigator>().pushNamed(ChangelogScreen.route),
          ),
          ListTile(
            leading: const Icon(LineAwesomeIcons.github),
            title: const Text('Harpy is open source'),
            subtitle: Text('github.com/robertodoering/harpy', style: linkStyle),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: kDefaultRadius,
                bottomRight: kDefaultRadius,
              ),
            ),
            onTap: () => launchUrl('https://github.com/robertodoering/harpy'),
          ),
        ],
      ),
    );
  }

  Widget _buildProText(ThemeData theme, TextStyle linkStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: DefaultEdgeInsets.all(),
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Support the development of Harpy and get access '
                        'to a number of exclusive features by purchasing ',
                  ),
                  TextSpan(
                    text: 'Harpy Pro',
                    style: linkStyle,
                  ),
                  const TextSpan(text: ' in the Play Store.'),
                ],
              ),
              style: theme.textTheme.subtitle2,
            ),
          ),
          ListTile(
            leading: const FlareIcon.shiningStar(size: 24),
            title: const Text('Harpy Pro'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: kDefaultRadius,
                bottomRight: kDefaultRadius,
              ),
            ),
            onTap: () => app<MessageService>().show('Coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppText(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: DefaultEdgeInsets.all(),
            child: Text(
              'Please rate Harpy in the Play Store!',
              style: theme.textTheme.subtitle2,
            ),
          ),
          ListTile(
            leading: const FlareIcon.shiningStar(size: 24),
            title: const Text('Rate Harpy'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: kDefaultRadius,
                bottomRight: kDefaultRadius,
              ),
            ),
            onTap: () => app<MessageService>().show('Coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperText(TextStyle linkStyle) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.mail),
            isThreeLine: true,
            title: Padding(
              padding: EdgeInsets.only(top: defaultPaddingValue),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'Developed by '),
                    TextSpan(text: 'Roberto Doering', style: linkStyle),
                  ],
                ),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: defaultPaddingValue),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: 'rbydoering@gmail.com\n', style: linkStyle),
                    const TextSpan(
                      text: 'Thank you for your feedback and bug reports!',
                    ),
                  ],
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(kDefaultRadius),
            ),
            onTap: () => launchUrl(mailto),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.privacy_tip),
        title: const Text('Privacy policy'),
        shape: kDefaultShapeBorder,
        onTap: () => launchUrl(_privacyPolicy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color color = textTheme.bodyText2.color;

    final TextStyle linkStyle = TextStyle(
      color: theme.accentColor,
      fontWeight: FontWeight.bold,
    );

    return HarpyScaffold(
      title: 'About',
      actions: <Widget>[
        PopupMenuButton<void>(
          onSelected: (_) => showLicensePage(context: context),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<void>>[
              const PopupMenuItem<void>(
                value: 0,
                child: Text('Show licenses'),
              ),
            ];
          },
        ),
      ],
      body: ListView(
        padding: DefaultEdgeInsets.all(),
        children: <Widget>[
          ..._buildTitleWithLogo(color),
          defaultSmallVerticalSpacer,
          _buildVersionCode(theme),
          defaultVerticalSpacer,
          _buildIntroductionText(theme, linkStyle),
          if (Harpy.isFree) ...<Widget>[
            defaultVerticalSpacer,
            _buildProText(theme, linkStyle),
          ],
          defaultVerticalSpacer,
          _buildRateAppText(theme),
          defaultVerticalSpacer,
          _buildDeveloperText(linkStyle),
          defaultVerticalSpacer,
          _buildPrivacyPolicy(),
          SizedBox(height: mediaQuery.padding.bottom),
        ],
      ),
    );
  }
}
