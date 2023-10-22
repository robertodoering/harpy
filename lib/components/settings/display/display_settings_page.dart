import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class DisplaySettingsPage extends ConsumerWidget {
  const DisplaySettingsPage();

  static const name = 'display_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('display'),
            actions: [
              RbyPopupMenuButton(
                onSelected: (_) => ref
                    .read(displayPreferencesProvider.notifier)
                    .defaultSettings(),
                itemBuilder: (_) => const [
                  RbyPopupMenuListTile(
                    value: true,
                    title: Text('reset to default'),
                  ),
                ],
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: theme.spacing.edgeInsets,
                child: const PreviewTweetCard(),
              ),
              Padding(
                padding: theme.spacing.edgeInsets.copyWith(top: 0),
                child: const _DisplaySettingsList(),
              ),
            ]),
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
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final notifier = ref.watch(displayPreferencesProvider.notifier);

    return Column(
      children: [
        ExpansionCard(
          title: const Text('font'),
          children: [
            const RbyListTile(
              leading: Icon(CupertinoIcons.textformat_size),
              title: Text('font size'),
            ),
            _FontSizeSlider(fontSizeDeltaId: display.fontSizeDeltaId),
            _FontRadioDialogTile(
              title: 'body font',
              pageTitle: 'select a body font',
              leadingIcon: CupertinoIcons.textformat,
              font: display.bodyFont,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                notifier.setBodyFont(value);
              },
            ),
            _FontRadioDialogTile(
              title: 'display font',
              pageTitle: 'select a display font',
              leadingIcon: CupertinoIcons.textformat,
              font: display.displayFont,
              borderRadius: BorderRadius.only(
                bottomLeft: theme.shape.radius,
                bottomRight: theme.shape.radius,
              ),
              onChanged: (value) {
                HapticFeedback.lightImpact();
                notifier.setDisplayFont(value);
              },
            ),
          ],
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.rectangle_compress_vertical),
            title: const Text('compact layout'),
            subtitle: const Text('use a visually dense layout'),
            value: display.compactMode,
            borderRadius: theme.shape.borderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              notifier.setCompactMode(value);
            },
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.calendar),
            title: const Text('show absolute tweet time'),
            value: display.absoluteTweetTime,
            borderRadius: theme.shape.borderRadius,
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

class _FontRadioDialogTile extends StatelessWidget {
  const _FontRadioDialogTile({
    required this.title,
    required this.pageTitle,
    required this.font,
    required this.onChanged,
    required this.leadingIcon,
    this.borderRadius,
  });

  final String title;
  final String pageTitle;
  final String font;
  final IconData leadingIcon;
  final ValueChanged<String> onChanged;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return RbyListTile(
      title: Text(title),
      leading: Icon(leadingIcon),
      subtitle: Text(font),
      borderRadius: borderRadius,
      onTap: () => context.goNamed(
        FontSelectionPage.name,
        extra: {
          'title': pageTitle,
          'selectedFont': font,
          'onChanged': onChanged,
        },
      ),
    );
  }
}
