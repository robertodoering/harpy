import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

class DisplaySettingsScreen extends StatelessWidget {
  const DisplaySettingsScreen();

  static const route = 'display_settings';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    final configCubit = context.watch<ConfigCubit>();
    final config = configCubit.state;

    return HarpyScaffold(
      title: 'display settings',
      actions: [
        CustomPopupMenuButton<void>(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onSelected: (_) {
            HapticFeedback.lightImpact();

            configCubit.resetToDefault();
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
              const HarpyListTile(
                leading: Icon(CupertinoIcons.textformat_size),
                title: Text('font size'),
              ),
              SliderTheme(
                data: theme.sliderTheme.copyWith(
                  activeTrackColor: theme.colorScheme.secondary,
                  thumbColor: theme.colorScheme.secondary,
                  valueIndicatorColor:
                      theme.colorScheme.secondary.withOpacity(.8),
                  valueIndicatorTextStyle: theme.textTheme.subtitle1!.copyWith(
                    color: theme.colorScheme.onSecondary,
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

                      configCubit.updateFontSizeDelta(value);
                    }
                  },
                ),
              ),
              _FontRadioDialogTile(
                title: 'body font',
                appBarTitle: 'select a body font',
                leadingIcon: CupertinoIcons.textformat,
                font: config.bodyFont,
                onChanged: (value) {
                  HapticFeedback.lightImpact();

                  configCubit.updateBodyFont(value);
                },
              ),
              _FontRadioDialogTile(
                title: 'display font',
                appBarTitle: 'select a display font',
                leadingIcon: CupertinoIcons.textformat,
                font: config.displayFont,
                onChanged: (value) {
                  HapticFeedback.lightImpact();

                  configCubit.updateDisplayFont(value);
                },
              ),
              HarpySwitchTile(
                leading: const Icon(CupertinoIcons.rectangle_compress_vertical),
                title: const Text('compact layout'),
                subtitle: const Text('use a visually dense layout'),
                value: config.compactMode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();

                  configCubit.updateCompactMode(value);
                },
              ),
              HarpySwitchTile(
                leading: const Icon(CupertinoIcons.calendar),
                title: const Text('show absolute tweet time'),
                value: config.showAbsoluteTime,
                onChanged: (value) {
                  HapticFeedback.lightImpact();

                  configCubit.updateShowAbsoluteTime(value);
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

class _FontRadioDialogTile extends StatelessWidget {
  const _FontRadioDialogTile({
    required this.title,
    required this.appBarTitle,
    required this.font,
    required this.onChanged,
    required this.leadingIcon,
  });

  final String title;
  final String appBarTitle;
  final String font;
  final IconData leadingIcon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return HarpyListTile(
      title: Text(title),
      leading: Icon(leadingIcon),
      subtitle: Text(font),
      onTap: () => app<HarpyNavigator>().push<String>(
        HarpyPageRoute(
          builder: (_) => FontSelectionScreen(
            selectedFont: font,
            title: appBarTitle,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
