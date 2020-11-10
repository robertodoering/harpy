import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/changelog/widgets/changelog_screen.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/url_launcher.dart';
import 'package:line_icons/line_icons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen();

  static const String route = 'about';

  static const String _mailto =
      'mailto:rbydoering+harpy@gmail.com?subject=Harpy';

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

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text('Version $version', style: theme.textTheme.subtitle2),
    );
  }

  Widget _buildIntroductionText(TextStyle linkStyle) {
    return ListTile(
      leading: const Icon(LineIcons.github),
      title: Text.rich(
        TextSpan(
          children: <TextSpan>[
            const TextSpan(text: 'Harpy is open source on '),
            TextSpan(text: 'GitHub', style: linkStyle),
            const TextSpan(text: '.'),
          ],
        ),
      ),
      subtitle: const Text('github.com/robertodoering/harpy'),
      onTap: () => launchUrl('https://github.com/robertodoering/harpy'),
    );
  }

  List<Widget> _buildProText(ThemeData theme, TextStyle linkStyle) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        leading: const FlareIcon.shiningStar(size: 22),
        title: const Text('Harpy Pro'),
        onTap: () => app<MessageService>().show('Coming soon!'),
      ),
    ];
  }

  List<Widget> _buildRateAppText(ThemeData theme) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Please rate Harpy in the Play Store!',
          style: theme.textTheme.subtitle2,
        ),
      ),
      ListTile(
        leading: const FlareIcon.shiningStar(size: 22),
        title: const Text('Rate Harpy'),
        onTap: () => app<MessageService>().show('Coming soon!'),
      ),
    ];
  }

  List<Widget> _buildDeveloperText(TextStyle linkStyle) {
    return <Widget>[
      ListTile(
        leading: const Icon(Icons.mail),
        title: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Developed by '),
              TextSpan(text: 'Roberto Doering', style: linkStyle),
            ],
          ),
        ),
        isThreeLine: true,
        subtitle: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: 'rbydoering@gmail.com\n', style: linkStyle),
              const TextSpan(
                text: 'Thank you for your feedback and bug reports!',
              ),
            ],
          ),
        ),
        onTap: () => launchUrl(_mailto),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ..._buildTitleWithLogo(color),
            _buildVersionCode(theme),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Version history'),
              onTap: () =>
                  app<HarpyNavigator>().pushNamed(ChangelogScreen.route),
            ),
            _buildIntroductionText(linkStyle),
            if (Harpy.isFree) ...<Widget>[
              const Divider(height: 32),
              ..._buildProText(theme, linkStyle),
            ],
            const Divider(height: 32),
            ..._buildRateAppText(theme),
            const Divider(height: 32),
            ..._buildDeveloperText(linkStyle),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
