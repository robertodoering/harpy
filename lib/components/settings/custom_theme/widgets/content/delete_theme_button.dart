import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';

/// Builds a button to delete a custom theme for the [CustomThemeScreen].
class DeleteThemeButton extends StatelessWidget {
  const DeleteThemeButton(this.bloc);

  final CustomThemeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: HarpyButton.raised(
        text: const Text('Delete theme'),
        onTap: () => bloc.add(const DeleteCustomTheme()),
      ),
    );
  }
}
