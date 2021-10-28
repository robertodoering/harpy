import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TwitterListMembers extends StatelessWidget {
  const TwitterListMembers({
    required this.list,
  });

  final TwitterListData list;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final cubit = context.watch<ListMembersCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: state.hasMoreData,
          onLoadMore: cubit.loadMore,
          child: UserList(
            state.members.toList(),
            beginSlivers: [
              HarpySliverAppBar(
                title: '${list.name} members',
                floating: true,
              )
            ],
            endSlivers: [
              ...?state.whenOrNull(
                loading: () => [
                  const UserListLoadingSliver(),
                ],
                error: () => [
                  SliverFillLoadingError(
                    message: const Text('error loading list members'),
                    onRetry: cubit.initialize,
                  ),
                ],
                noData: () => [
                  SliverFillLoadingError(
                    message: const Text('no members found'),
                    onRetry: cubit.initialize,
                  ),
                ],
                loadingMore: (_) => [
                  const SliverBoxLoadingIndicator(),
                ],
              ),
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
