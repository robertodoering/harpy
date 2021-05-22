import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class FontSettingsScreen extends StatefulWidget {
  const FontSettingsScreen();

  static const String route = 'font_settings';

  @override
  _FontSettingsScreenState createState() => _FontSettingsScreenState();
}

class _FontSettingsScreenState extends State<FontSettingsScreen> {
  final LayoutPreferences layoutPreferences = app<LayoutPreferences>();

  List<Widget> _buildSettings(ThemeBloc themeBloc) {
    return <Widget>[
      //TODO extract to custom widget "PreviewTweetCard"
      ListTile(
        title: const Text('preview'),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TweetCard(
            TweetData.fromTweet(
              Tweet()
                ..idStr = '-1'
                ..fullText =
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, '
                        'sed diam nonumy eirmod tempor invidunt ut labore '
                        'et dolore magna aliquyam erat, sed diam voluptua. '
                        'At vero eos et accusam et justo duo dolores et ea '
                        'rebum. Stet clita kasd gubergren, no sea takimata '
                        'sanctus est Lorem ipsum dolor sit amet.'
                ..user = (User()
                  ..name = 'Harpy'
                  ..screenName = 'Harpy'
                  ..profileImageUrlHttps =
                      'https://pbs.twimg.com/profile_images/1356691241140957190'
                          '/N03_GPid_400x400.jpg'),
            ),
          ),
        ),
      ),
      //TODO extract to custom widget "SliderListTile"
      ListTile(
        leading: const Icon(CupertinoIcons.textformat_size),
        title: const Text('font size delta'),
        subtitle: Slider(
          label: '${layoutPreferences.fontSizeDelta}',
          value: layoutPreferences.fontSizeDelta,
          onChanged: (newValue) {
            HapticFeedback.lightImpact();
            setState(() {
              layoutPreferences.fontSizeDelta = newValue;
              themeBloc.add(const RefreshTheme());
            });
          },
          min: -4,
          max: 4,
          divisions: 4,
        ),
      ),
      const ListTile(
        leading: Icon(CupertinoIcons.textformat),
        title: Text('font type'),
        subtitle: Text('coming soon!'),
        enabled: false,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = ThemeBloc.of(context);

    return HarpyScaffold(
      title: 'font settings',
      body: ListView(
        padding: EdgeInsets.zero,
        children: _buildSettings(themeBloc),
      ),
    );
  }
}
