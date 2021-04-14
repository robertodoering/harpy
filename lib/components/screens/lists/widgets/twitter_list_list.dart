import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TwitterListList extends StatelessWidget {
  const TwitterListList();

  Widget _itemBuilder(int index, List<TwitterListData> lists) {
    if (index.isEven) {
      return TwitterListCard(lists[index ~/ 2]);
    } else {
      return defaultVerticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ListsBloc bloc = context.watch<ListsBloc>();
    final ListsState state = bloc.state;

    if (state.isLoading) {
      return const SliverFillLoadingIndicator();
    } else if (state.hasFailed) {
      return const SliverFillInfoMessage(
        secondaryMessage: Text('error requesting lists'),
      );
    } else if (state.hasResult) {
      return SliverPadding(
        padding: DefaultEdgeInsets.all(),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _itemBuilder(index, state.lists),
            childCount: state.lists.length * 2 - 1,
          ),
        ),
      );
    } else {
      return const SliverFillInfoMessage(
        secondaryMessage: Text('no lists exist'),
      );
    }
  }
}
