import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class FontSelection extends StatefulWidget {
  const FontSelection({
    required this.title,
    required this.selectedFont,
  });

  final String title;
  final String selectedFont;

  @override
  State<FontSelection> createState() => _FontSelectionState();
}

class _FontSelectionState extends State<FontSelection> {
  late final Iterable<String> _googleFonts;

  String _filter = '';

  @override
  void initState() {
    super.initState();

    _googleFonts = GoogleFonts.asMap()
        .keys
        .where((element) => !kAssetFonts.contains(element));
  }

  Widget _buildProCard(Config config, ThemeData theme) {
    return HarpyProCard(
      children: [
        const Text(
          'all fonts are available in the pro '
          'version of harpy',
        ),
        Text(
          '(coming soon)',
          style: theme.textTheme.subtitle2!.copyWith(
            color: Colors.white.withOpacity(.6),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    final filteredFonts = _googleFonts
        .where((font) => font.toLowerCase().contains(_filter.toLowerCase()));

    final children = [
      if (Harpy.isFree) ...[
        _buildProCard(config, theme),
        defaultSmallVerticalSpacer,
      ],
      for (final font in kAssetFonts)
        _FontCard(
          font: font,
          selected: font == widget.selectedFont,
          assetFont: true,
        ),
      defaultVerticalSpacer,
      TextField(
        decoration: const InputDecoration(hintText: 'search'),
        onChanged: (value) => setState(() => _filter = value),
      ),
      defaultVerticalSpacer,
      for (final font in filteredFonts)
        _FontCard(
          font: font,
          selected: font == widget.selectedFont,
        ),
    ];

    return HarpyScaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: CustomScrollView(
          slivers: [
            HarpySliverAppBar(
              title: widget.title,
              floating: true,
            ),
            SliverPadding(
              padding: config.edgeInsets,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => index.isEven
                      ? children[index ~/ 2]
                      : defaultSmallVerticalSpacer,
                  childCount: children.length * 2 - 1,
                  addAutomaticKeepAlives: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class _FontCard extends StatefulWidget {
  const _FontCard({
    required this.font,
    this.selected = false,
    this.assetFont = false,
  });

  final String font;
  final bool selected;
  final bool assetFont;

  @override
  State<_FontCard> createState() => _FontCardState();
}

class _FontCardState extends State<_FontCard> {
  late bool _selected;
  late bool _preview;

  @override
  void initState() {
    super.initState();

    _selected = widget.selected;
    _preview = widget.assetFont || widget.selected;
  }

  TextStyle get _style {
    final style = Theme.of(context).textTheme.subtitle2!;

    if (_preview) {
      return applyGoogleFont(textStyle: style, fontFamily: widget.font);
    } else {
      return style;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyListCard(
      border: _selected
          ? Border.all(color: theme.colorScheme.primary)
          : _preview
              ? Border.all(color: theme.dividerColor)
              : null,
      title: Text(widget.font, style: _style),
      trailing: Harpy.isFree && !widget.assetFont
          ? const FlareIcon.shiningStar(size: 22)
          : null,
      onTap: _preview && (Harpy.isPro || widget.assetFont)
          ? () {
              // update border during screen transition
              setState(() => _selected = true);
              Navigator.of(context).pop(widget.font);
            }
          : () => setState(() => _preview = true),
    );
  }
}
