import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/animations/animation_constants.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class DisplaySettingsScreen extends StatelessWidget {
  const DisplaySettingsScreen();

  static const String route = 'display_settings';

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
              FontRadioDialogTile(
                title: 'body font',
                leadingIcon: CupertinoIcons.textformat,
                font: config.bodyFont.fontFamily,
                onChanged: (value) {
                  if (value != null) {
                    configCubit.updateBodyFont(value);
                  }
                },
              ),
              FontRadioDialogTile(
                title: 'display font',
                leadingIcon: CupertinoIcons.textformat,
                font: config.displayFont.fontFamily,
                onChanged: (value) {
                  if (value != null) {
                    configCubit.updateDisplayFont(value);
                  }
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

class FontRadioDialogTile extends StatelessWidget {
  const FontRadioDialogTile({
    required this.title,
    required this.font,
    required this.onChanged,
    required this.leadingIcon,
  });

  final String title;
  final String font;
  final IconData leadingIcon;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final assetFonts = ['OpenSans', 'Comfortaa'];

    final googleFonts = GoogleFonts.asMap().keys.toList().take(20);

    final availableFonts = [
      ...assetFonts,
      ...googleFonts,
    ];

    return RadioDialogTile<String>(
      value: font,
      leading: leadingIcon,
      title: title,
      description: '',
      subtitle: font,
      titles: availableFonts,
      values: availableFonts,
      onChanged: onChanged,
    );
  }
}
