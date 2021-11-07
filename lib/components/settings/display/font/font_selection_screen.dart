import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class FontSelectionScreen extends StatelessWidget {
  const FontSelectionScreen({
    required this.title,
    required this.selectedFont,
    required this.onChanged,
  });

  final String title;
  final String selectedFont;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FontSelectionCubit(),
      child: HarpyScaffold(
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: _FontSelectionList(
            title: title,
            initialSelection: selectedFont,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _FontSelectionList extends StatefulWidget {
  const _FontSelectionList({
    required this.title,
    required this.initialSelection,
    required this.onChanged,
  });

  final String title;
  final String initialSelection;
  final ValueChanged<String> onChanged;

  @override
  State<_FontSelectionList> createState() => _FontSelectionListState();
}

class _FontSelectionListState extends State<_FontSelectionList>
    with RouteAware {
  late String _selectedFont;

  @override
  void initState() {
    super.initState();

    _selectedFont = widget.initialSelection;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    harpyRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    harpyRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    if (Harpy.isPro || Harpy.isFree && kAssetFonts.contains(_selectedFont)) {
      widget.onChanged(_selectedFont);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<FontSelectionCubit>();

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
          selected: font == _selectedFont,
          style: style.copyWith(fontFamily: font),
          onSelect: () => setState(() => _selectedFont = font),
          onConfirm: Navigator.of(context).pop,
        ),
      defaultVerticalSpacer,
      TextField(
        decoration: const InputDecoration(hintText: 'search'),
        onChanged: cubit.updateFilter,
      ),
      for (final font in cubit.state)
        FontCard(
          font: font,
          selected: font == _selectedFont,
          style: applyGoogleFont(textStyle: style, fontFamily: _selectedFont),
          onSelect: () => setState(() => _selectedFont = font),
          onConfirm: Navigator.of(context).pop,
        ),
    ];

    return CustomScrollView(
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
