import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/animations/animation_constants.dart';
import 'package:provider/provider.dart';

class DisplaySettingsScreen extends StatelessWidget {
  const DisplaySettingsScreen();

  static const String route = 'display_settings';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    final configBloc = context.watch<ConfigBloc>();
    final config = configBloc.state;

    return HarpyScaffold(
      title: 'display settings',
      actions: [
        CustomPopupMenuButton<void>(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onSelected: (_) {
            HapticFeedback.lightImpact();

            configBloc.add(const ResetToDefaultConfig());
          },
          itemBuilder: (_) => [
            const HarpyPopupMenuItem<int>(
              value: 0,
              text: Text('reset to default'),
            ),
          ],
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedPadding(
                duration: kShortAnimationDuration,
                curve: Curves.easeInOut,
                padding: config.edgeInsets,
                child: const PreviewTweetCard(),
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.textformat_size),
                title: const Text('font size'),
                subtitle: SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    valueIndicatorColor:
                        theme.colorScheme.primary.withOpacity(.8),
                    valueIndicatorTextStyle:
                        theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 13,
                    ),
                  ),
                  child: Slider(
                    value: config.fontSizeDelta,
                    label: config.fontSizeDeltaName,
                    min: -4,
                    max: 4,
                    divisions: 4,
                    onChanged: (value) {
                      if (value != config.fontSizeDelta) {
                        HapticFeedback.lightImpact();

                        configBloc.add(
                          UpdateFontSizeDelta(fontSizeDelta: value),
                        );
                      }
                    },
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(CupertinoIcons.textformat),
                title: Text('font type'),
                subtitle: Text('coming soon!'),
                enabled: false,
              ),
              SwitchListTile(
                secondary: const Icon(
                  CupertinoIcons.rectangle_compress_vertical,
                ),
                title: const Text('Compact layout'),
                subtitle: const Text('use a visually dense layout'),
                value: config.compactMode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();

                  configBloc.add(UpdateCompactMode(compactMode: value));
                },
              ),
              SizedBox(
                height: mediaQuery.padding.bottom,
              )
            ],
          )
        ],
      ),
    );
  }
}
