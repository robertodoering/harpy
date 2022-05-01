import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
        Text('background colors', style: theme.textTheme.headline4),
        verticalSpacer,
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
    final display = ref.watch(displayPreferencesProvider);

    return ReorderableList(
      physics: const NeverScrollableScrollPhysics(),
      dragStartBehavior: DragStartBehavior.down,
      itemBuilder: (_, index) {
        final color = harpyTheme.colors.backgroundColors[index].value;

        final trailing = notifier.canReorderBackgroundColor
            ? ReorderableDragStartListener(
                index: index,
                child: Container(
                  color: Colors.transparent,
                  padding: display.edgeInsets,
                  child: const Icon(CupertinoIcons.bars),
                ),
              )
            : Container(
                color: Colors.transparent,
                padding: display.edgeInsets,
                child: Icon(
                  CupertinoIcons.bars,
                  color: theme.iconTheme.color!.withOpacity(.5),
                ),
              );

        return Padding(
          key: ValueKey(hashValues(color, index)),
          padding: EdgeInsets.only(bottom: display.smallPaddingValue),
          child: ClipRRect(
            borderRadius: harpyTheme.borderRadius,
            child: CustomThemeColor(
              color: Color(color),
              padding: EdgeInsets.zero,
              leading: HarpyButton.icon(
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

class _AddBackgroundColor extends ConsumerWidget {
  const _AddBackgroundColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return AnimatedCrossFade(
      duration: kShortAnimationDuration,
      sizeCurve: Curves.fastOutSlowIn,
      firstChild: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: harpyTheme.borderRadius,
        ),
        child: HarpyListTile(
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add background color'),
          borderRadius: harpyTheme.borderRadius,
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
