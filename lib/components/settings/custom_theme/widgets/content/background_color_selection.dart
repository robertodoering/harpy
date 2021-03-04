import 'package:flutter/material.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/add_background_color_card.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/background_color_card.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the background color customization for the [CustomThemeScreen].
class BackgroundColorSelection extends StatelessWidget {
  const BackgroundColorSelection(this.bloc);

  final CustomThemeBloc bloc;

  Widget _buildBackgroundColor(BuildContext context, int index) {
    return BackgroundColorCard(
      bloc: bloc,
      index: index,
      color: bloc.harpyTheme.backgroundColors[index],
    );
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
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: Text('background colors', style: textTheme.headline4),
        ),
        defaultVerticalSpacer,
        ReorderableList(
          itemBuilder: _buildBackgroundColor,
          itemCount: harpyTheme.backgroundColors.length,
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) {
            bloc.add(ReorderBackgroundColor(
              oldIndex: oldIndex,
              newIndex: newIndex > oldIndex ? newIndex - 1 : newIndex,
            ));
          },
        ),
        AddBackgroundColorCard(bloc),
      ],
    );
  }
}
