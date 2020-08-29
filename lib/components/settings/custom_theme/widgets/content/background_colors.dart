import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/color_picker_dialog.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds the background color selection for a custom theme.
class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors(this.bloc);

  final CustomThemeBloc bloc;

  String _nameFromIndex(int index) {
    // todo: move to string utils
    if (index == 0) {
      return 'First';
    } else if (index == 1) {
      return 'Second';
    } else if (index == 2) {
      return 'Third';
    } else if (index == 3) {
      return 'Fourth';
    } else {
      return 'Fifth';
    }
  }

  List<Widget> _buildBackgroundColors(HarpyTheme harpyTheme) {
    return <Widget>[
      for (int i = 0; i < harpyTheme.backgroundColors.length; i++)
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: harpyTheme.backgroundColors[i],
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text('${_nameFromIndex(i)} background color'),
                // todo: change color
                onTap: () {},
              ),
            ),
          ),
        )
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
          onTap: () async {
            final Color color = await showDialog<Color>(
              context: context,
              builder: (BuildContext context) => ColorPickerDialog(
                color: harpyTheme.backgroundColors.first,
              ),
            );

            // todo: add background color
          },
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
        ..._buildBackgroundColors(harpyTheme),
        _buildAddBackgroundColor(context, harpyTheme),
      ],
    );
  }
}
