import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/buttons/harpy_button.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

class TwitterLists extends StatelessWidget {
  const TwitterLists({
    this.onListSelected,
  });

  final ValueChanged<TwitterListData>? onListSelected;

  Widget _itemBuilder(
    int index,
    List<TwitterListData> lists,
    BuildContext context,
  ) {
    if (index.isEven) {
      final list = lists[index ~/ 2];

      return TwitterListCard(
        list,
        key: Key(list.idStr),
        onSelected: onListSelected != null
            ? () => onListSelected!(list)
            : () => app<HarpyNavigator>().pushListTimelineScreen(list: list),
        onLongPress: () => _showListActionBottomSheet(context, list),
      );
    } else {
      return defaultVerticalSpacer;
    }
  }

  int? _indexCallback(Key key, List<TwitterListData> lists) {
    if (key is ValueKey<String>) {
      final index = lists.indexWhere(
        (list) => list.idStr == key.value,
      );

      if (index != -1) {
        return index * 2;
      }
    }

    return null;
  }

  List<Widget> _buildOwnerships(
    BuildContext context,
    Config config,
    ListsShowBloc bloc,
    ListsShowState state,
  ) {
    return [
      SliverPadding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        sliver: const SliverBoxInfoMessage(
          primaryMessage: Text('owned'),
        ),
      ),
      SliverPadding(
        padding: config.edgeInsets,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => _itemBuilder(index, state.ownerships, context),
            findChildIndexCallback: (key) =>
                _indexCallback(key, state.ownerships),
            childCount: state.ownerships.length * 2 - 1,
          ),
        ),
      ),
      if (state.hasMoreOwnerships || state.loadingMoreOwnerships)
        SliverPadding(
          padding: config.edgeInsetsOnly(bottom: true),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: AnimatedSwitcher(
                duration: kShortAnimationDuration,
                child: state.hasMoreOwnerships
                    ? HarpyButton.flat(
                        text: const Text('load more'),
                        onTap: () => bloc.add(const LoadMoreOwnerships()),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildSubscriptions(
    BuildContext context,
    Config config,
    ListsShowBloc bloc,
    ListsShowState state,
  ) {
    return [
      SliverPadding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        sliver: const SliverBoxInfoMessage(
          primaryMessage: Text('subscribed'),
        ),
      ),
      SliverPadding(
        padding: config.edgeInsets,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => _itemBuilder(index, state.subscriptions, context),
            findChildIndexCallback: (key) =>
                _indexCallback(key, state.subscriptions),
            childCount: state.subscriptions.length * 2 - 1,
          ),
        ),
      ),
      if (state.hasMoreSubscriptions || state.loadingMoreSubscriptions)
        SliverPadding(
          padding: config.edgeInsetsOnly(bottom: true),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: AnimatedSwitcher(
                duration: kShortAnimationDuration,
                child: state.hasMoreSubscriptions
                    ? HarpyButton.flat(
                        text: const Text('load more'),
                        onTap: () => bloc.add(const LoadMoreSubscriptions()),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
    ];
  }

  void _showListActionBottomSheet(BuildContext context, TwitterListData list) {
    showHarpyBottomSheet<void>(
      context,
      children: [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.person_3),
          title: const Text('show members'),
          onTap: () {
            Navigator.of(context).pop();
            app<HarpyNavigator>().pushListMembersScreen(list: list);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ListsShowBloc>();
    final state = bloc.state;

    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(title: 'lists', floating: true),
        if (state.isLoading)
          const SliverFillLoadingIndicator()
        else if (state.hasFailed)
          SliverFillLoadingError(
            message: const Text('error requesting lists'),
            onRetry: () => bloc.add(const ShowLists()),
          )
        else if (state.hasResult) ...[
          if (state.hasOwnerships)
            ..._buildOwnerships(
              context,
              config,
              bloc,
              state,
            ),
          if (state.hasSubscriptions)
            ..._buildSubscriptions(
              context,
              config,
              bloc,
              state,
            ),
        ] else
          const SliverFillInfoMessage(
            secondaryMessage: Text('no lists exist'),
          ),
        SliverToBoxAdapter(
          child: SizedBox(height: mediaQuery.padding.bottom),
        ),
      ],
    );
  }
}
