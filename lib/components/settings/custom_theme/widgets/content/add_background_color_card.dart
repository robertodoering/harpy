import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a card to add a background color for the [CustomThemeBloc].
class AddBackgroundColorCard extends StatelessWidget {
  const AddBackgroundColorCard(this.bloc);

  final CustomThemeBloc bloc;

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = bloc.harpyTheme;

    return AnimatedCrossFade(
      duration: kShortAnimationDuration,
      sizeCurve: Curves.fastOutSlowIn,
      firstChild: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: harpyTheme.data.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: const Icon(Icons.add),
            title: const Text('Add background color'),
            onTap: () {
              if (bloc.canAddMoreBackgroundColors) {
                bloc.add(const AddBackgroundColor());
              }
            },
          ),
        ),
      ),
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: bloc.canAddMoreBackgroundColors
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
