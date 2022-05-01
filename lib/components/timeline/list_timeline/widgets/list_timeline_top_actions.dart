import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ListTimelineTopActions extends ConsumerWidget {
  const ListTimelineTopActions({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: display.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            _RefreshButton(listId: listId),
            const Spacer(),
            _ListMembersButton(listId: listId, listName: listName),
            horizontalSpacer,
            _FilterButton(listId: listId, listName: listName),
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends ConsumerWidget {
  const _RefreshButton({
    required this.listId,
  });

  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listTimelineProvider(listId));
    final notifier = ref.watch(listTimelineProvider(listId).notifier);

    return HarpyButton.card(
      icon: const Icon(CupertinoIcons.refresh),
      onTap: state.tweets.isNotEmpty
          ? () {
              HapticFeedback.lightImpact();
              UserScrollDirection.of(context)?.idle();
              notifier.load(clearPrevious: true);
            }
          : null,
    );
  }
}

class _ListMembersButton extends ConsumerWidget {
  const _ListMembersButton({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final state = ref.watch(listTimelineProvider(listId));

    return HarpyButton.card(
      icon: const Icon(CupertinoIcons.person_2),
      onTap: state.tweets.isNotEmpty
          ? () => router.pushNamed(
                ListMembersPage.name,
                params: {'listId': listId},
                queryParams: {'name': listName},
              )
          : null,
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final router = ref.watch(routerProvider);
    final state = ref.watch(listTimelineProvider(listId));
    final notifier = ref.watch(listTimelineProvider(listId).notifier);

    return HarpyButton.card(
      icon: notifier.filter != null
          ? Icon(
              Icons.filter_alt,
              color: state.tweets.isNotEmpty
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(.5),
            )
          : const Icon(Icons.filter_alt_outlined),
      onTap: state.tweets.isNotEmpty
          ? () => router.pushNamed(
                ListTimelineFilter.name,
                params: {'listId': listId},
                queryParams: {'name': listName},
              )
          : null,
    );
  }
}
