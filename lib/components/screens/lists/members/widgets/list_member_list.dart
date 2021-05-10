import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/lists/members/bloc/list_member_bloc.dart';
import 'package:provider/provider.dart';

class ListMemberList extends StatelessWidget {
  const ListMemberList({required this.list});

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ListMemberBloc>();
    final state = bloc.state;

    final members = state.members;

    return ScrollToStart(
      child: LoadMoreListener(
        listen: state.loadingMore,
        onLoadMore: () async => bloc.add(LoadMoreMembers()),
        child: UserList(
          members,
          beginSlivers: <Widget>[
            HarpySliverAppBar(
              title: list.name,
              floating: true,
            )
          ],
          endSlivers: <Widget>[
            if (state.isLoading) const SliverFillLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
