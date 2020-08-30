import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/dialogs/color_picker_dialog.dart';
import 'package:harpy/components/common/list/custom_reorderable_list.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the background color selection for a custom theme.
class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors(this.bloc);

  final CustomThemeBloc bloc;

  List<Widget> _buildBackgroundColors(
    BuildContext context,
    HarpyTheme harpyTheme,
  ) {
    return <Widget>[
      for (int i = 0; i < harpyTheme.backgroundColors.length; i++)
        _BackgroundColorTile(
          bloc: bloc,
          index: i,
          color: harpyTheme.backgroundColors[i],
        ),
    ];
  }

  Widget _buildAddBackgroundColor(BuildContext context, HarpyTheme harpyTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: harpyTheme.data.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.add),
          title: const Text('Add background color'),
          onTap: () => bloc.add(const AddBackgroundColor()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = bloc.harpyTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomReorderableList(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) => bloc.add(
            ReorderBackgroundColor(oldIndex: oldIndex, newIndex: newIndex),
          ),
          children: _buildBackgroundColors(context, harpyTheme),
        ),
        if (bloc.canAddMoreBackgroundColors)
          _buildAddBackgroundColor(context, harpyTheme),
      ],
    );
  }
}

class _BackgroundColorTile extends StatelessWidget {
  _BackgroundColorTile({
    @required this.bloc,
    @required this.color,
    @required this.index,
  }) : super(key: ValueKey<int>(hashValues(color, index)));

  final CustomThemeBloc bloc;
  final Color color;
  final int index;

  Future<void> _changeBackgroundColor(BuildContext context) async {
    final Color newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) => ColorPickerDialog(
        color: color,
      ),
    );

    if (newColor != null) {
      bloc.add(ChangeBackgroundColor(index: index, color: newColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo: icon / text theme based on color
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: color,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ListTile(
                  leading: const SizedBox(),
                  trailing: const SizedBox(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () => _changeBackgroundColor(context),
                ),
                HarpyButton.flat(
                  icon: Icons.delete_outline,
                  padding: const EdgeInsets.all(16),
                  onTap: bloc.canRemoveBackgroundColor
                      ? () => bloc.add(RemoveBackgroundColor(index: index))
                      : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ReorderableListener(
                    // wrap in container to have the reorderable listener catch
                    // gestures on transparency
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      child: const Icon(Icons.drag_handle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
