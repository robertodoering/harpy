import 'package:flutter/material.dart';
import 'package:harpy/components/about/widgets/about_screen.dart';
import 'package:harpy/components/beta_info/widgets/faq.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/misc/url_launcher.dart';

class BetaInfoScreen extends StatelessWidget {
  const BetaInfoScreen();

  static const String route = 'beta_info_screen';

  VoidCallback get launchEmail => () => launchUrl(AboutScreen.mailto);

  VoidCallback get launchPlayStore => () => launchUrl(
      'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.free');

  Widget _buildIntroText(ThemeData theme) {
    return ContentCard(
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text: 'Harpy is currently in development.\n\n'
                    'I appreciate every feedback you sent me. You can reach '
                    'out to me via ',
              ),
              WidgetSpan(child: LinkText(text: 'email', onTap: launchEmail)),
              const TextSpan(text: ' and through the '),
              WidgetSpan(
                child: LinkText(text: 'Play Store', onTap: launchPlayStore),
              ),
              const TextSpan(text: ' test feedback.'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return HarpyScaffold(
      title: 'Beta info',
      body: ListView(
        padding: DefaultEdgeInsets.all(),
        children: <Widget>[
          _buildIntroText(theme),
          defaultVerticalSpacer,
          Center(child: Text('FAQ', style: theme.textTheme.subtitle1)),
          defaultVerticalSpacer,
          BetaFaq(onEmailTap: launchEmail),
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    @required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: DefaultEdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  const LinkText({
    @required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: theme.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
