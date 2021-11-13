import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TwitterListMembers extends StatelessWidget {
  const TwitterListMembers({
    this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bloc = context.watch<ListMembersBloc>();
    final state = bloc.state;
    final sortedUser = state.members
        ..sort((a, b) => b.followersCount.compareTo(a.followersCount));
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: state.hasMoreData,
          onLoadMore: () async {
            bloc.add(const LoadMoreMembers());
            await bloc.requestMoreCompleter.future;
          },
          child: UserList(
            sortedUser,
            beginSlivers: [
              HarpySliverAppBar(
                title: name != null ? '$name members' : 'members',
                floating: true,
              )
            ],
            endSlivers: [
              if (state.isLoading)
                const UserListLoadingSliver()
              else if (state.isFailure)
                SliverFillLoadingError(
                  message: const Text('error loading list members'),
                  onRetry: () => bloc.add(const ShowListMembers()),
                )
              else if (state.hasNoMembers)
                SliverFillLoadingError(
                  message: const Text('no members found'),
                  onRetry: () => bloc.add(const ShowListMembers()),
                ),
              if (state.loadingMore) const SliverBoxLoadingIndicator(),
              SliverToBoxAdapter(
                child: SizedBox(height: mediaQuery.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
