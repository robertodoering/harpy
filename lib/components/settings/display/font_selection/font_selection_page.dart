import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class FontSelectionPage extends StatefulWidget {
  const FontSelectionPage({
    required this.title,
    required this.selectedFont,
    required this.onChanged,
  });

  final String title;
  final String selectedFont;
  final ValueChanged<String> onChanged;

  static const name = 'font_selection';

  @override
  State<FontSelectionPage> createState() => _FontSelectionPageState();
}

class _FontSelectionPageState extends State<FontSelectionPage> {
  late String _selectedFont = widget.selectedFont;

  Future<bool> _onWillPop() async {
    if (isPro || isFree && kAssetFonts.contains(_selectedFont)) {
      widget.onChanged(_selectedFont);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: HarpyScaffold(
        child: ScrollDirectionListener(
          child: ScrollToTop(
            child: CustomScrollView(
              slivers: [
                HarpySliverAppBar(title: Text(widget.title)),
                if (isFree)
                  SliverPadding(
                    padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
                    sliver: const SliverToBoxAdapter(
                      child: HarpyProCard(
                        children: [
                          Text(
                            'all fonts are available in '
                            'the pro version of harpy',
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
                  sliver: const _PreviewHint(),
                ),
                SliverPadding(
                  padding: theme.spacing.edgeInsets,
                  sliver: _AssetFonts(
                    selectedFont: _selectedFont,
                    onSelect: (font) => setState(() => _selectedFont = font),
                  ),
                ),
                SliverPadding(
                  padding: theme.spacing.symmetric(horizontal: true),
                  sliver: const _FontsFilterTextField(),
                ),
                SliverPadding(
                  padding: theme.spacing.edgeInsets,
                  sliver: _SelectableFonts(
                    selectedFont: _selectedFont,
                    onSelect: (font) => setState(() => _selectedFont = font),
                  ),
                ),
                const SliverBottomPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewHint extends ConsumerStatefulWidget {
  const _PreviewHint();

  @override
  _PreviewHintState createState() => _PreviewHintState();
}

class _PreviewHintState extends ConsumerState<_PreviewHint> {
  late final _gestureRecognizer = TapGestureRecognizer()
    ..onTap = () => ref.read(launcherProvider)('https://fonts.google.com/');

  @override
  void dispose() {
    super.dispose();

    _gestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Row(
        children: [
          HorizontalSpacer.normal,
          Icon(
            CupertinoIcons.info,
            color: theme.colorScheme.primary,
          ),
          HorizontalSpacer.normal,
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'preview fonts on '),
                  TextSpan(
                    text: 'fonts.google.com',
                    recognizer: _gestureRecognizer,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: theme.textTheme.titleSmall!.apply(
                fontSizeDelta: -2,
              ),
            ),
          ),
          HorizontalSpacer.normal,
        ],
      ),
    );
  }
}

class _FontsFilterTextField extends ConsumerWidget {
  const _FontsFilterTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(fontSelectionProvider.notifier);

    return SliverToBoxAdapter(
      child: TextField(
        decoration: const InputDecoration(hintText: 'search'),
        onChanged: notifier.updateFilter,
      ),
    );
  }
}

class _AssetFonts extends StatelessWidget {
  const _AssetFonts({
    required this.selectedFont,
    required this.onSelect,
  });

  final String selectedFont;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        for (final font in kAssetFonts) ...[
          FontCard(
            font: font,
            assetFont: true,
            selected: font == selectedFont,
            style: TextStyle(fontFamily: font),
            onSelect: () => onSelect(font),
            onConfirm: Navigator.of(context).maybePop,
          ),
          if (font != kAssetFonts.last) VerticalSpacer.small,
        ],
      ]),
    );
  }
}

class _SelectableFonts extends ConsumerWidget {
  const _SelectableFonts({
    required this.selectedFont,
    required this.onSelect,
  });

  final String selectedFont;
  final ValueChanged<String> onSelect;

  Widget? _builder(BuildContext context, int index, BuiltList<String> fonts) {
    return index.isEven
        ? FontCard(
            font: fonts[index ~/ 2],
            assetFont: true,
            selected: fonts[index ~/ 2] == selectedFont,
            style: applyFontFamily(
              textStyle: const TextStyle(),
              fontFamily: selectedFont,
            ),
            onSelect: () => onSelect(fonts[index ~/ 2]),
            onConfirm: Navigator.of(context).maybePop,
          )
        : VerticalSpacer.small;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fonts = ref.watch(fontSelectionProvider);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _builder(context, index, fonts),
        childCount: fonts.length * 2 - 1,
        addAutomaticKeepAlives: false,
      ),
    );
  }
}
