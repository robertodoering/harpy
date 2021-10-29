import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class FontScreen extends StatelessWidget {
  const FontScreen({
    required this.selectedFont,
  });

  final String selectedFont;

  Widget _buildProCard(Config config, ThemeData theme) {
    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: HarpyProCard(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final googleFonts = GoogleFonts.asMap()
        .keys
        .where((element) => !kAssetFonts.contains(element))
        .toList();

    final availableFonts = [
      ...kAssetFonts,
      if (Harpy.isPro) ...googleFonts,
    ];

    final children = [
      if (Harpy.isFree) _buildProCard(config, theme),
      for (String font in availableFonts)
        FontCard(
          font: font,
          selected: font == selectedFont,
          onTap: () {
            app<HarpyNavigator>().pop(font);
          },
        ),
      if (Harpy.isFree)
        for (String font in googleFonts) ProFontCard(font: font),
    ];

    return HarpyScaffold(
      title: 'select a font',
      buildSafeArea: true,
      body: ListView.separated(
        padding: config.edgeInsets,
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => defaultSmallVerticalSpacer,
        itemCount: children.length,
      ),
    );
  }
}

class ProFontCard extends StatelessWidget {
  const ProFontCard({
    required this.font,
  });

  final String font;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return _FontCardBase(
      child: Padding(
        padding: config.edgeInsets,
        child: Row(
          children: [
            Expanded(
              child: Text(
                font,
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const FlareIcon.shiningStar(size: 22),
          ],
        ),
      ),
    );
  }
}

class FontCard extends StatelessWidget {
  const FontCard({
    required this.font,
    required this.onTap,
    this.selected = false,
  });

  final String font;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return _FontCardBase(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: config.edgeInsets,
          child: Text(
            font,
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _FontCardBase extends StatelessWidget {
  const _FontCardBase({
    required this.child,
    this.selected = false,
  });

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        border: selected
            ? Border.all(color: theme.primaryColor)
            : Border.all(color: Colors.transparent),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
