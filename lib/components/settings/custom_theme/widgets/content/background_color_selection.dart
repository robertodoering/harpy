import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/custom_reorderable_list.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/add_background_color_card.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/background_color_card.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the background color customization for the [CustomThemeScreen].
class BackgroundColorSelection extends StatelessWidget {
  const BackgroundColorSelection(this.bloc);

  final CustomThemeBloc bloc;

  List<Widget> _buildBackgroundColors(
    BuildContext context,
    HarpyTheme harpyTheme,
  ) {
    return <Widget>[
      for (int i = 0; i < harpyTheme.backgroundColors.length; i++)
        BackgroundColorCard(
          bloc: bloc,
          index: i,
          color: harpyTheme.backgroundColors[i],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = bloc.harpyTheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Background colors', style: textTheme.headline4),
        ),
        const SizedBox(height: 8),
        CustomReorderableList(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) => bloc.add(
            ReorderBackgroundColor(oldIndex: oldIndex, newIndex: newIndex),
          ),
          children: _buildBackgroundColors(context, harpyTheme),
        ),
        AddBackgroundColorCard(bloc),
      ],
    );
  }
}
