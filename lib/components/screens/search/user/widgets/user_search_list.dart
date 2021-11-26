import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class UserSearchList extends StatelessWidget {
  const UserSearchList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserSearchCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: state.canLoadMore,
          onLoadMore: cubit.loadMore,
          child: UserList(
            state.data?.users.toList() ?? [],
            beginSlivers: const [_SearchAppBar()],
            endSlivers: [
              ...?state.mapOrNull(
                loading: (_) => [const UserListLoadingSliver()],
                loadingMore: (_) => [const LoadMoreIndicator()],
                noData: (_) => const [
                  SliverFillInfoMessage(
                    primaryMessage: Text('no users found'),
                  ),
                ],
                error: (_) => const [
                  SliverFillLoadingError(
                    message: Text('error searching users'),
                  ),
                ],
              ),
              const SliverBottomPadding(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchAppBar extends StatelessWidget {
  const _SearchAppBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserSearchCubit>();

    return HarpySliverAppBar(
      titleWidget: SearchTextField(
        autofocus: true,
        hintText: 'search users',
        onSubmitted: (text) {
          if (text.trim().isNotEmpty) {
            cubit.search(text.trim());
          }
        },
        onClear: cubit.clear,
      ),
      floating: true,
    );
  }
}
