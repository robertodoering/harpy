import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds a button to delete a custom theme for the [CustomThemeScreen].
class DeleteThemeButton extends StatelessWidget {
  const DeleteThemeButton(this.bloc);

  final CustomThemeBloc bloc;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    return Padding(
      padding: config.edgeInsets,
      child: HarpyButton.raised(
        text: const Text('delete theme'),
        onTap: () => bloc.add(const DeleteCustomTheme()),
      ),
    );
  }
}
