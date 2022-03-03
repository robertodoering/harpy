import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class DisplaySettingsPage extends ConsumerWidget {
  const DisplaySettingsPage();

  static const name = 'display_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('display'),
            actions: [
              HarpyPopupMenuButton(
                onSelected: (_) => ref
                    .read(displayPreferencesProvider.notifier)
                    .defaultSettings(),
                itemBuilder: (_) => const [
                  HarpyPopupMenuItem(title: Text('reset to default')),
                ],
              ),
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: AnimatedPadding(
                      duration: kShortAnimationDuration,
                      curve: Curves.easeInOut,
                      padding: display.edgeInsets,
                      child: const PreviewTweetCard(),
                    ),
                  ),
                ),
                Padding(
                  padding: display.edgeInsets,
                  child: const _DisplaySettingsList(),
                ),
              ],
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _DisplaySettingsList extends ConsumerWidget {
  const _DisplaySettingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final notifier = ref.watch(displayPreferencesProvider.notifier);

    return Column(
      children: [
        ExpansionCard(
          title: const Text('font'),
          initiallyCollapsed: true,
          children: [
            const HarpyListTile(
              leading: Icon(CupertinoIcons.textformat_size),
              title: Text('font size'),
            ),
            _FontSizeSlider(fontSizeDeltaId: display.fontSizeDeltaId),
            _FontRadioDialogTile(
              title: 'body font',
              appBarTitle: 'select a body font',
              leadingIcon: CupertinoIcons.textformat,
              font: display.bodyFont,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                notifier.setBodyFont(value);
              },
            ),
            _FontRadioDialogTile(
              title: 'display font',
              appBarTitle: 'select a display font',
              leadingIcon: CupertinoIcons.textformat,
              font: display.displayFont,
              borderRadius: BorderRadius.only(
                bottomLeft: harpyTheme.radius,
                bottomRight: harpyTheme.radius,
              ),
              onChanged: (value) {
                HapticFeedback.lightImpact();
                notifier.setDisplayFont(value);
              },
            ),
          ],
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(CupertinoIcons.rectangle_compress_vertical),
            title: const Text('compact layout'),
            subtitle: const Text('use a visually dense layout'),
            value: display.compactMode,
            borderRadius: harpyTheme.borderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              notifier.setCompactMode(value);
            },
          ),
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(CupertinoIcons.calendar),
            title: const Text('show absolute tweet time'),
            value: display.absoluteTweetTime,
            borderRadius: harpyTheme.borderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              notifier.setAbsoluteTweetTime(value);
            },
          ),
        ),
      ],
    );
  }
}

class _FontSizeSlider extends ConsumerStatefulWidget {
  const _FontSizeSlider({
    required this.fontSizeDeltaId,
  });

  final int fontSizeDeltaId;

  @override
  _FontSizeSliderState createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends ConsumerState<_FontSizeSlider> {
  late int _id;

  @override
  void initState() {
    super.initState();

    _id = widget.fontSizeDeltaId;
  }

  String _fontSizeNameFromId(int id) {
    const names = {
      -2: 'smallest',
      -1: 'small',
      0: 'normal',
      1: 'big',
      2: 'biggest',
    };

    return names[id] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final notifier = ref.watch(displayPreferencesProvider.notifier);

    return Slider(
      value: display.fontSizeDeltaId.toDouble(),
      label: _fontSizeNameFromId(display.fontSizeDeltaId),
      min: -2,
      max: 2,
      divisions: 4,
      onChanged: (value) {
        final id = value.toInt();

        if (id != _id) {
          _id = id;
          HapticFeedback.lightImpact();
          notifier.setFontSizeDeltaId(value.toInt());
        }
      },
    );
  }
}

class _FontRadioDialogTile extends ConsumerWidget {
  const _FontRadioDialogTile({
    required this.title,
    required this.appBarTitle,
    required this.font,
    required this.onChanged,
    required this.leadingIcon,
    this.borderRadius,
  });

  final String title;
  final String appBarTitle;
  final String font;
  final IconData leadingIcon;
  final ValueChanged<String> onChanged;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final router = ref.watch(routerProvider);

    return HarpyListTile(
      title: Text(title),
      leading: Icon(leadingIcon),
      subtitle: Text(font),
      borderRadius: borderRadius,
      // TODO: font selection page
      // onTap: () => app<HarpyNavigator>().push<String>(
      //   HarpyPageRoute(
      //     builder: (_) => FontSelectionScreen(
      //       selectedFont: font,
      //       title: appBarTitle,
      //       onChanged: onChanged,
      //     ),
      //   ),
      // ),
    );
  }
}
