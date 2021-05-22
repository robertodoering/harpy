import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/settings/layout/font/widgets/preview_tweet_card.dart';
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
      PreviewTweetCard(),
      ListTile(
        leading: const Icon(CupertinoIcons.textformat_size),
        title: const Text('font size delta'),
        subtitle: Slider(
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
