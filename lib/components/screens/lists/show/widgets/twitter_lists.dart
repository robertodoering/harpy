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

  final ValueChanged<TwitterListData> onListSelected;

  Widget _itemBuilder(int index, List<TwitterListData> lists) {
    if (index.isEven) {
      final TwitterListData list = lists[index ~/ 2];

      return TwitterListCard(
        list,
        key: Key(list.idStr),
        onSelected: onListSelected != null
            ? () => onListSelected(list)
            : () => app<HarpyNavigator>().pushListTimelineScreen(
                  list: list,
                ),
      );
    } else {
      return defaultVerticalSpacer;
    }
  }

  int _indexCallback(Key key, List<TwitterListData> lists) {
    if (key is ValueKey<String>) {
      final int index = lists.indexWhere(
        (TwitterListData list) => list.idStr == key.value,
      );

      if (index != -1) {
        return index * 2;
      }
    }

    return null;
  }

  List<Widget> _buildOwnerships(ListsShowBloc bloc, ListsShowState state) {
    return <Widget>[
      SliverPadding(
        padding: DefaultEdgeInsets.symmetric(horizontal: true),
        sliver: const SliverBoxInfoMessage(
          primaryMessage: Text('owned'),
        ),
      ),
      SliverPadding(
        padding: DefaultEdgeInsets.all(),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _itemBuilder(index, state.ownerships),
            findChildIndexCallback: (Key key) =>
                _indexCallback(key, state.ownerships),
            childCount: state.ownerships.length * 2 - 1,
          ),
        ),
      ),
      if (state.hasMoreOwnerships || state.loadingMoreOwnerships)
        SliverPadding(
          padding: DefaultEdgeInsets.only(bottom: true),
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

  List<Widget> _buildSubscriptions(ListsShowBloc bloc, ListsShowState state) {
    return <Widget>[
      SliverPadding(
        padding: DefaultEdgeInsets.symmetric(horizontal: true),
        sliver: const SliverBoxInfoMessage(
          primaryMessage: Text('subscribed'),
        ),
      ),
      SliverPadding(
        padding: DefaultEdgeInsets.all(),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _itemBuilder(index, state.subscriptions),
            findChildIndexCallback: (Key key) =>
                _indexCallback(key, state.subscriptions),
            childCount: state.subscriptions.length * 2 - 1,
          ),
        ),
      ),
      if (state.hasMoreSubscriptions || state.loadingMoreSubscriptions)
        SliverPadding(
          padding: DefaultEdgeInsets.only(bottom: true),
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

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final ListsShowBloc bloc = context.watch<ListsShowBloc>();
    final ListsShowState state = bloc.state;

    return CustomScrollView(
      slivers: <Widget>[
        const HarpySliverAppBar(title: 'lists', floating: true),
        if (state.isLoading)
          const SliverFillLoadingIndicator()
        else if (state.hasFailed)
          SliverFillLoadingError(
            message: const Text('error requesting lists'),
            onRetry: () => bloc.add(const ShowLists()),
          )
        else if (state.hasResult) ...<Widget>[
          if (state.hasOwnerships) ..._buildOwnerships(bloc, state),
          if (state.hasSubscriptions) ..._buildSubscriptions(bloc, state),
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
