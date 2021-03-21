import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

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
