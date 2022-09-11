import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class FontSelectionPage extends ConsumerStatefulWidget {
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
  ConsumerState<FontSelectionPage> createState() => _FontSelectionPageState();
}

class _FontSelectionPageState extends ConsumerState<FontSelectionPage> {
  late String _selectedFont = widget.selectedFont;

  Future<bool> _onWillPop() async {
    if (isPro || isFree && kAssetFonts.contains(_selectedFont)) {
      widget.onChanged(_selectedFont);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);

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
                    padding: display.edgeInsets.copyWith(bottom: 0),
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
                  padding: display.edgeInsets.copyWith(bottom: 0),
                  sliver: const _PreviewHint(),
                ),
                SliverPadding(
                  padding: display.edgeInsets,
                  sliver: _AssetFonts(
                    selectedFont: _selectedFont,
                    onSelect: (font) => setState(() => _selectedFont = font),
                  ),
                ),
                SliverPadding(
                  padding: display.edgeInsetsSymmetric(horizontal: true),
                  sliver: const _FontsFilterTextField(),
                ),
                SliverPadding(
                  padding: display.edgeInsets,
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
          horizontalSpacer,
          Icon(
            CupertinoIcons.info,
            color: theme.colorScheme.primary,
          ),
          horizontalSpacer,
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
          horizontalSpacer,
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
          if (font != kAssetFonts.last) smallVerticalSpacer,
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
        : smallVerticalSpacer;
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
