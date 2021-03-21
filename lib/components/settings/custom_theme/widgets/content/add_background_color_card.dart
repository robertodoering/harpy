import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
        margin: DefaultEdgeInsets.symmetric(horizontal: true),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: harpyTheme.data.dividerColor),
          borderRadius: kDefaultBorderRadius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            shape: kDefaultShapeBorder,
            leading: const Icon(CupertinoIcons.add),
            title: const Text('add background color'),
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
