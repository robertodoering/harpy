import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class CustomThemeBackgroundColors extends ConsumerWidget {
  const CustomThemeBackgroundColors({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('background colors', style: theme.textTheme.headlineMedium),
        VerticalSpacer.normal,
        _ReorderableBackgroundColors(notifier: notifier),
        _AddBackgroundColor(notifier: notifier),
      ],
    );
  }
}

class _ReorderableBackgroundColors extends ConsumerWidget {
  const _ReorderableBackgroundColors({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ReorderableList(
      physics: const NeverScrollableScrollPhysics(),
      dragStartBehavior: DragStartBehavior.down,
      itemBuilder: (_, index) {
        final color = harpyTheme.colors.backgroundColors[index].value;

        final trailing = notifier.canReorderBackgroundColor
            ? HarpyReorderableDragStartListener(
                index: index,
                child: Container(
                  color: Colors.transparent,
                  padding: theme.spacing.edgeInsets,
                  child: const Icon(CupertinoIcons.bars),
                ),
              )
            : Container(
                color: Colors.transparent,
                padding: theme.spacing.edgeInsets,
                child: Icon(
                  CupertinoIcons.bars,
                  color: theme.iconTheme.color!.withOpacity(.5),
                ),
              );

        return Padding(
          key: ValueKey(Object.hash(color, index)),
          padding: EdgeInsetsDirectional.only(
            bottom: theme.spacing.small,
          ),
          child: ClipRRect(
            borderRadius: theme.shape.borderRadius,
            child: CustomThemeColor(
              color: Color(color),
              padding: EdgeInsets.zero,
              leading: RbyButton.transparent(
                icon: const Icon(CupertinoIcons.xmark, size: 20),
                onTap: notifier.canRemoveBackgroundColor
                    ? () => notifier.removeBackgroundColor(index)
                    : null,
              ),
              trailing: trailing,
              onColorChanged: (color) => notifier.changeBackgroundColor(
                index,
                color,
              ),
            ),
          ),
        );
      },
      itemCount: harpyTheme.colors.backgroundColors.length,
      shrinkWrap: true,
      onReorder: (oldIndex, newIndex) => notifier.reorderBackgroundColor(
        oldIndex,
        newIndex > oldIndex ? newIndex - 1 : newIndex,
      ),
    );
  }
}

class _AddBackgroundColor extends StatelessWidget {
  const _AddBackgroundColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedCrossFade(
      duration: theme.animation.short,
      sizeCurve: Curves.fastOutSlowIn,
      firstChild: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: theme.shape.borderRadius,
        ),
        child: RbyListTile(
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add background color'),
          borderRadius: theme.shape.borderRadius,
          onTap: notifier.addBackgroundColor,
        ),
      ),
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: notifier.canAddBackgroundColor
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
