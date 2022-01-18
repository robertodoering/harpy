import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

class TwitterLists extends StatelessWidget {
  const TwitterLists({
    this.onListSelected,
  });

  final ValueChanged<TwitterListData>? onListSelected;

  Widget _itemBuilder(
    BuildContext context,
    int index,
    BuiltList<TwitterListData> lists,
  ) {
    if (index.isEven) {
      final listData = lists[index ~/ 2];

      return TwitterListCard(
        listData,
        key: Key(listData.id),
        onSelected: onListSelected != null
            ? () => onListSelected!(listData)
            : () => app<HarpyNavigator>().pushListTimelineScreen(
                  listId: listData.id,
                  listName: listData.name,
                ),
        onLongPress: () => _showListActionBottomSheet(context, listData),
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

      if (index != -1) {
        return index * 2;
      }
    }

    return null;
  }

  List<Widget> _buildLists({
    required Config config,
    required String title,
    required BuiltList<TwitterListData> listData,
    required bool hasMore,
    required bool loadingMore,
    required VoidCallback onLoadMore,
  }) {
    return [
      SliverPadding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        sliver: SliverBoxInfoMessage(primaryMessage: Text(title)),
      ),
      SliverPadding(
        padding: config.edgeInsets,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _itemBuilder(context, index, listData),
            findChildIndexCallback: (key) => _indexCallback(key, listData),
            childCount: listData.length * 2 - 1,
          ),
        ),
      ),
      if (hasMore || loadingMore)
        SliverPadding(
          padding: config.edgeInsetsOnly(bottom: true),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: AnimatedSwitcher(
                duration: kShortAnimationDuration,
                child: hasMore
                    ? HarpyButton.flat(
                        text: const Text('load more'),
                        onTap: onLoadMore,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildOwnerships(Config config, ListsShowBloc bloc) {
    return _buildLists(
      config: config,
      title: 'owned',
      listData: bloc.state.ownerships,
      hasMore: bloc.state.hasMoreOwnerships,
      loadingMore: bloc.state.loadingMoreOwnerships,
      onLoadMore: () => bloc.add(const ListsShowEvent.loadMoreOwnerships()),
    );
  }

  List<Widget> _buildSubscriptions(Config config, ListsShowBloc bloc) {
    return _buildLists(
      config: config,
      title: 'subscribed',
      listData: bloc.state.subscriptions,
      hasMore: bloc.state.hasMoreSubscriptions,
      loadingMore: bloc.state.loadingMoreSubscriptions,
      onLoadMore: () => bloc.add(const ListsShowEvent.loadMoreSubscriptions()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ListsShowBloc>();
    final state = bloc.state;

    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(title: 'lists', floating: true),
        ...?state.mapOrNull(
          loading: (_) => [const SliverFillLoadingIndicator()],
          error: (_) => [
            SliverFillLoadingError(
              message: const Text('error requesting lists'),
              onRetry: () => bloc.add(const ListsShowEvent.show()),
            ),
          ],
          data: (value) => [
            if (value.ownerships.isNotEmpty)
              ..._buildOwnerships(
                config,
                bloc,
              ),
            if (value.subscriptions.isNotEmpty)
              ..._buildSubscriptions(
                config,
                bloc,
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

void _showListActionBottomSheet(BuildContext context, TwitterListData list) {
  showHarpyBottomSheet<void>(
    context,
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.person_2),
        title: const Text('show members'),
        onTap: () {
          Navigator.of(context).pop();
          app<HarpyNavigator>().pushListMembersScreen(
            listId: list.id,
            listName: list.name,
          );
        },
      )
    ],
  );
}
