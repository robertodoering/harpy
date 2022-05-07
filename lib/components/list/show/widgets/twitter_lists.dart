import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TwitterLists extends ConsumerWidget {
  const TwitterLists({
    required this.userId,
    this.onListSelected,
  });

  final String userId;
  final ValueChanged<TwitterListData>? onListSelected;

  Widget _itemBuilder(
    BuildContext context,
    Reader read,
    int index,
    BuiltList<TwitterListData> lists,
  ) {
    if (index.isEven) {
      final list = lists[index ~/ 2];

      return TwitterListCard(
        // key is used for the SliverChildDelegate's indexCallback
        key: ValueKey(list.id),
        list: list,
        onSelected: onListSelected != null
            ? () => onListSelected!(list)
            : () => read(routerProvider).pushNamed(
                  ListTimelinePage.name,
                  params: {'listId': list.id},
                  queryParams: {'name': list.name},
                ),
        onLongPress: () => _showListActionBottomSheet(
          context,
          read,
          list: list,
        ),
      );
    } else {
      return verticalSpacer;
    }
  }

  int? _indexCallback(Key key, BuiltList<TwitterListData> lists) {
    if (key is ValueKey<String>) {
      final index = lists.indexWhere(
        (list) => list.id == key.value,
      );

      if (index != -1) return index * 2;
    }

    return null;
  }

  List<Widget> _buildLists({
    required Reader read,
    required String title,
    required BuiltList<TwitterListData> lists,
    required bool hasMore,
    required bool loadingMore,
    required VoidCallback onLoadMore,
  }) {
    final display = read(displayPreferencesProvider);

    return [
      SliverPadding(
        padding: display.edgeInsetsSymmetric(horizontal: true),
        sliver: SliverBoxInfoMessage(primaryMessage: Text(title)),
      ),
      SliverPadding(
        padding: display.edgeInsets,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _itemBuilder(context, read, index, lists),
            findChildIndexCallback: (key) => _indexCallback(key, lists),
            childCount: lists.length * 2 - 1,
          ),
        ),
      ),
      if (hasMore || loadingMore)
        SliverPadding(
          padding: display.edgeInsetsOnly(bottom: true),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: HarpyAnimatedSwitcher(
                child: hasMore
                    ? HarpyButton.text(
                        label: const Text('load more'),
                        onTap: onLoadMore,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listShowProvider(userId));
    final notifier = ref.watch(listShowProvider(userId).notifier);

    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(title: Text('lists')),
        ...?state.mapOrNull(
          loading: (_) => [const SliverFillLoadingIndicator()],
          error: (_) => [
            SliverFillLoadingError(
              message: const Text('error requesting lists'),
              onRetry: notifier.load,
            ),
          ],
          data: (value) => [
            if (value.ownerships.isNotEmpty)
              ..._buildLists(
                read: ref.read,
                title: 'owned',
                lists: value.ownerships,
                hasMore: value.hasMoreOwnerships,
                loadingMore: value.loadingMoreOwnerships,
                onLoadMore: notifier.loadMoreOwnerships,
              ),
            if (value.subscriptions.isNotEmpty)
              ..._buildLists(
                read: ref.read,
                title: 'subscribed',
                lists: value.subscriptions,
                hasMore: value.hasMoreSubscriptions,
                loadingMore: value.loadingMoreSubscriptions,
                onLoadMore: notifier.loadMoreSubscriptions,
              ),
          ],
          noData: (_) => [
            const SliverFillInfoMessage(
              secondaryMessage: Text('no lists exist'),
            ),
          ],
        ),
        const SliverBottomPadding(),
      ],
    );
  }
}

void _showListActionBottomSheet(
  BuildContext context,
  Reader read, {
  required TwitterListData list,
}) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.person_2),
        title: const Text('show members'),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
          read(routerProvider).pushNamed(
            ListMembersPage.name,
            params: {'listId': list.id},
            queryParams: {'name': list.name},
          );
        },
      )
    ],
  );
}
