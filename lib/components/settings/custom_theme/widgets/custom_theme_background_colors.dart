import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.paddingValue * 2),
          child: Text('background colors', style: theme.textTheme.headline4),
        ),
        verticalSpacer,
        const _ReorderableBackgroundColors(),
        const _AddBackgroundColor(),
      ],
    );
  }
}

class _ReorderableBackgroundColors extends StatelessWidget {
  const _ReorderableBackgroundColors();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return ReorderableList(
      physics: const NeverScrollableScrollPhysics(),
      dragStartBehavior: DragStartBehavior.down,
      itemBuilder: (_, index) {
        final color = cubit.state.backgroundColors[index];

        final trailing = cubit.canReorderBackgroundColor
            ? ReorderableDragStartListener(
                index: index,
                child: Container(
                  color: Colors.transparent,
                  padding: config.edgeInsets,
                  child: const Icon(CupertinoIcons.bars),
                ),
              )
            : Container(
                color: Colors.transparent,
                padding: config.edgeInsets,
                child: Icon(
                  CupertinoIcons.bars,
                  color: theme.iconTheme.color!.withOpacity(.5),
                ),
              );

        return Padding(
          key: ValueKey(hashValues(color, index)),
          padding: EdgeInsets.only(
            left: config.paddingValue,
            right: config.paddingValue,
            bottom: config.smallPaddingValue,
          ),
          child: Provider<CustomThemeCubit>.value(
            value: cubit,
            child: CustomThemeColor(
              color: Color(color),
              padding: EdgeInsets.zero,
              leading: HarpyButton.flat(
                icon: const Icon(CupertinoIcons.xmark, size: 20),
                padding: config.edgeInsets,
                onTap: cubit.canRemoveBackgroundColor
                    ? () => cubit.removeBackgroundColor(index)
                    : null,
              ),
              trailing: trailing,
              onColorChanged: (color) {
                cubit.changeBackgroundColor(index, color);
              },
            ),
          ),
        );
      },
      itemCount: cubit.state.backgroundColors.length,
      shrinkWrap: true,
      onReorder: (oldIndex, newIndex) => cubit.reorderBackgroundColor(
        oldIndex,
        newIndex > oldIndex ? newIndex - 1 : newIndex,
      ),
    );
  }
}

class _AddBackgroundColor extends StatelessWidget {
  const _AddBackgroundColor();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return AnimatedCrossFade(
      duration: kShortAnimationDuration,
      sizeCurve: Curves.fastOutSlowIn,
      firstChild: Container(
        margin: config.edgeInsetsSymmetric(horizontal: true),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: kBorderRadius,
        ),
        child: HarpyListTile(
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add background color'),
          borderRadius: kBorderRadius,
          onTap: cubit.addBackgroundColor,
        ),
      ),
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: cubit.canAddBackgroundColor
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
