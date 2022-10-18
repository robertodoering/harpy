import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class HomeTabCustomization extends ConsumerWidget {
  const HomeTabCustomization();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final configuration = ref.watch(homeTabConfigurationProvider);

    return ListView(
      padding: theme.spacing.edgeInsets,
      children: [
        const HomeTopPadding(),
        if (isFree) ...[
          const HarpyProCard(
            children: [
              Text(
                'home content customization is only available in the pro '
                'version of harpy',
              ),
            ],
          ),
          VerticalSpacer.small,
        ] else
          const _HomeTabResetToDefaultCard(),
        VerticalSpacer.small,
        const _HomeTabReorderList(),
        if (configuration.canAddMoreLists) const HomeTabAddListCard(),
      ],
    );
  }
}

class _HomeTabReorderList extends ConsumerWidget {
  const _HomeTabReorderList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuration = ref.watch(homeTabConfigurationProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);

    return ReorderableList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: configuration.entries.length,
      onReorder: notifier.reorder,
      itemBuilder: (_, index) => HomeTabReorderCard(
        key: Key(configuration.entries[index].id),
        index: index,
      ),
    );
  }
}

class _HomeTabResetToDefaultCard extends ConsumerWidget {
  const _HomeTabResetToDefaultCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);

    return RbyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.clear),
      title: const Text('reset to default'),
      border: Border.all(color: theme.dividerColor),
      onTap: notifier.setToDefault,
    );
  }
}
