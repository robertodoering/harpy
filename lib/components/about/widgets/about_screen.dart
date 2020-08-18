import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen();

  static const String route = 'about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Map<String, GestureRecognizer> _recognizer =
      <String, GestureRecognizer>{};

  @override
  void initState() {
    super.initState();

    _recognizer['github'] = TapGestureRecognizer()
      ..onTap = () => launchUrl('https://github.com/robertodoering/harpy');

    _recognizer['email'] = TapGestureRecognizer()
      ..onTap = () => launchUrl('mailto:rbydoering+harpy@gmail.com'
          '?subject=Harpy');
  }

  @override
  void dispose() {
    super.dispose();
    for (GestureRecognizer recognizer in _recognizer.values) {
      recognizer.dispose();
    }
  }

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

  Widget _buildVersionCode(TextStyle style) {
    final String version = app<HarpyInfo>().packageInfo.version;

    return Center(child: Text('Version $version', style: style));
  }

  Widget _buildIntroductionText(TextStyle linkStyle) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          const TextSpan(text: 'Harpy is open source on '),
          TextSpan(
            text: 'GitHub',
            style: linkStyle,
            recognizer: _recognizer['github'],
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  List<Widget> _buildProText(Color accentColor, TextStyle linkStyle) {
    return <Widget>[
      const Text(
        'To support the development of Harpy, please buy Harpy Pro '
        'in the Play Store.',
      ),
      const SizedBox(height: 16),
      Center(
        child: HarpyButton.raised(
          text: 'Harpy Pro',
          iconBuilder: (BuildContext context) => const FlareIcon.shiningStar(
            size: 22,
          ),
          backgroundColor: accentColor,
          dense: true,
          // todo: link to harpy pro
          // todo: add harpy pro analytics
          onTap: () => app<MessageService>().showInfo('Not yet available'),
        ),
      ),
    ];
  }

  List<Widget> _buildRateAppText(Color accentColor) {
    return <Widget>[
      const Text('Please rate Harpy in the Play Store!'),
      const SizedBox(height: 16),
      Center(
        child: HarpyButton.raised(
          text: 'Rate Harpy',
          iconBuilder: (BuildContext context) => const FlareIcon.shiningStar(
            size: 22,
          ),
          backgroundColor: accentColor,
          dense: true,
          // todo harpy free or pro playstore link
          // todo: add rate harpy analytics
          onTap: () => app<MessageService>().showInfo('Not yet available'),
        ),
      ),
    ];
  }

  List<Widget> _buildDeveloperText(Color accentColor, TextStyle linkStyle) {
    return <Widget>[
      const Text('Developed by Roberto Doering'),
      Text.rich(TextSpan(
        text: 'rbydoering@gmail.com',
        style: linkStyle,
        recognizer: _recognizer['email'],
      )),
      const SizedBox(height: 16),
      const Text('Thank you for your feedback and bug reports!'),
      const SizedBox(height: 16),
      Center(
        child: HarpyButton.raised(
          text: 'Contact',
          icon: Icons.mail,
          backgroundColor: accentColor,
          dense: true,
          onTap: () => launchUrl(
            'mailto:rbydoering+harpy@gmail.com?subject=Harpy feedback',
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color color = textTheme.bodyText2.color;

    final TextStyle linkStyle = textTheme.bodyText2.copyWith(
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
                child: Text('Show licences'),
              ),
            ];
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._buildTitleWithLogo(color),
              _buildVersionCode(textTheme.subtitle2),
              const Divider(height: 32),
              _buildIntroductionText(linkStyle),
              if (Harpy.isFree) ...<Widget>[
                const Divider(height: 32),
                ..._buildProText(theme.accentColor, linkStyle)
              ],
              const Divider(height: 32),
              ..._buildRateAppText(theme.accentColor),
              const Divider(height: 32),
              ..._buildDeveloperText(theme.accentColor, linkStyle),
            ],
          ),
        ),
      ),
    );
  }
}
