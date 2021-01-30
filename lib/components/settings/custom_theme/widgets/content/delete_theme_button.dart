import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

/// Builds a button to delete a custom theme for the [CustomThemeScreen].
class DeleteThemeButton extends StatelessWidget {
  const DeleteThemeButton(this.bloc);

  final CustomThemeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DefaultEdgeInsets.all(),
      child: HarpyButton.raised(
        text: const Text('delete theme'),
        onTap: () => bloc.add(const DeleteCustomTheme()),
      ),
    );
  }
}
