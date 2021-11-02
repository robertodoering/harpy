import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class FontSelectionScreen extends StatelessWidget {
  const FontSelectionScreen({
    required this.title,
    required this.selectedFont,
  });

  final String title;
  final String selectedFont;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FontSelectionCubit(initialPreview: selectedFont),
      child: HarpyScaffold(
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: _FontSelectionList(
            title: title,
            selectedFont: selectedFont,
          ),
        ),
      ),
    );
  }
}

class _FontSelectionList extends StatelessWidget {
  const _FontSelectionList({
    required this.title,
    required this.selectedFont,
  });

  final String title;
  final String selectedFont;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<FontSelectionCubit>();
    final state = cubit.state;

    final style = theme.textTheme.subtitle2!;

    final children = [
      if (Harpy.isFree) ...[
        const _FontSelectionProCard(),
        defaultSmallVerticalSpacer,
      ],
      for (final font in kAssetFonts)
        FontCard(
          font: font,
          assetFont: true,
          selected: font == selectedFont,
          previewed: font == state.preview,
          style: style.copyWith(fontFamily: font),
          onPreview: () => cubit.selectPreview(font),
        ),
      defaultVerticalSpacer,
      TextField(
        decoration: const InputDecoration(hintText: 'search'),
        onChanged: cubit.updateFilter,
      ),
      for (final font in state.fonts)
        FontCard(
          font: font,
          selected: font == selectedFont,
          previewed: font == state.preview,
          style: applyGoogleFont(textStyle: style, fontFamily: state.preview),
          onPreview: () => cubit.selectPreview(font),
        ),
    ];

    return CustomScrollView(
      slivers: [
        HarpySliverAppBar(
          title: title,
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
    );
  }
}

class _FontSelectionProCard extends StatelessWidget {
  const _FontSelectionProCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
}
