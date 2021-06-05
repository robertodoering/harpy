import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen();

  static const String route = 'display_settings';

  @override
  _DisplaySettingsScreenState createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  final LayoutPreferences layoutPreferences = app<LayoutPreferences>();

  Widget _buildSettings(ThemeBloc themeBloc, MediaQueryData mediaQuery) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              // workaround to rebuild the tweet card with new compact layout
              // settings
              key: Key(layoutPreferences.compactMode.toString()),
              padding: DefaultEdgeInsets.all(),
              child: const PreviewTweetCard(),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(CupertinoIcons.textformat_size),
              title: const Text('font size'),
              subtitle: Slider(
                value: layoutPreferences.fontSizeDelta,
                label: layoutPreferences.currentFontSizeDeltaName,
                min: layoutPreferences.minFontSizeDelta,
                max: layoutPreferences.maxFontSizeDelta,
                divisions: 4,
                onChanged: (newValue) {
                  if (newValue != layoutPreferences.fontSizeDelta) {
                    HapticFeedback.lightImpact();

                    setState(() {
                      layoutPreferences.fontSizeDelta = newValue;
                      themeBloc.add(const RefreshTheme());
                    });
                  }
                },
              ),
            ),
            const ListTile(
              leading: Icon(CupertinoIcons.textformat),
              title: Text('font type'),
              subtitle: Text('coming soon!'),
              enabled: false,
            ),
            SwitchListTile(
              secondary: const Icon(CupertinoIcons.rectangle_compress_vertical),
              title: const Text('Compact layout'),
              subtitle: const Text('use a visually dense layout'),
              value: layoutPreferences.compactMode,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => layoutPreferences.compactMode = value);
              },
            ),
            SizedBox(
              height: mediaQuery.padding.bottom,
            )
          ],
        )
      ],
    );
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    return <Widget>[
      CustomPopupMenuButton<void>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (_) {
          HapticFeedback.lightImpact();
          setState(layoutPreferences.defaultSettings);
        },
        itemBuilder: (_) {
          return <PopupMenuEntry<int>>[
            const HarpyPopupMenuItem<int>(
              value: 0,
              text: Text('reset to default'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = ThemeBloc.of(context);
    final mediaQuery = MediaQuery.of(context);

    return HarpyScaffold(
      title: 'display settings',
      actions: _buildActions(),
      body: _buildSettings(themeBloc, mediaQuery),
    );
  }
}
