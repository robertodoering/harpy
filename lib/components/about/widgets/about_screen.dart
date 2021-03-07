import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/changelog/widgets/changelog_screen.dart';
import 'package:harpy/components/common/buttons/custom_popup_menu_button.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_popup_menu_item.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/url_launcher.dart';

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

  Widget _buildIntroductionText(ThemeData theme, TextStyle linkStyle) {
    final String version = app<HarpyInfo>().packageInfo.version;

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
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
            leading: const Icon(FeatherIcons.github),
            title: const Text('harpy is open source'),
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
            padding: const EdgeInsets.all(16),
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
          ListTile(
            leading: const FlareIcon.shiningStar(
              size: 28,
              offset: Offset(-4, 0),
            ),
            title: const Text('harpy pro'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: kDefaultRadius,
                bottomRight: kDefaultRadius,
              ),
            ),
            onTap: () => app<MessageService>().show('coming soon!'),
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
            padding: const EdgeInsets.all(16),
            child: Text(
              'please rate harpy in the play store!',
              style: theme.textTheme.subtitle2,
            ),
          ),
          ListTile(
            leading: const FlareIcon.shiningStar(
              size: 28,
              offset: Offset(-4, 0),
            ),
            title: const Text('rate harpy'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: kDefaultRadius,
                bottomRight: kDefaultRadius,
              ),
            ),
            onTap: () => app<MessageService>().show('coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperText(TextStyle linkStyle, TextTheme textTheme) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(FeatherIcons.mail),
            isThreeLine: true,
            title: Padding(
              padding: EdgeInsets.only(top: defaultPaddingValue),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'developed by '),
                    TextSpan(text: 'roberto doering\n', style: linkStyle),
                    TextSpan(text: 'rbydoering@gmail.com', style: linkStyle),
                  ],
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                'thank you for your feedback and bug reports!',
                style: textTheme.subtitle2,
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
        leading: const Icon(CupertinoIcons.exclamationmark_shield),
        title: const Text('privacy policy'),
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
      title: 'about',
      actions: <Widget>[
        CustomPopupMenuButton<void>(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onSelected: (_) => showLicensePage(context: context),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<void>>[
              const HarpyPopupMenuItem<void>(
                value: 0,
                text: Text('show licenses'),
              ),
            ];
          },
        ),
      ],
      body: ListView(
        padding: DefaultEdgeInsets.all(),
        children: <Widget>[
          ..._buildTitleWithLogo(color),
          defaultVerticalSpacer,
          _buildIntroductionText(theme, linkStyle),
          if (Harpy.isFree) ...<Widget>[
            defaultVerticalSpacer,
            _buildProText(theme, linkStyle),
          ],
          defaultVerticalSpacer,
          _buildRateAppText(theme),
          defaultVerticalSpacer,
          _buildDeveloperText(linkStyle, textTheme),
          defaultVerticalSpacer,
          _buildPrivacyPolicy(),
          SizedBox(height: mediaQuery.padding.bottom),
        ],
      ),
    );
  }
}
