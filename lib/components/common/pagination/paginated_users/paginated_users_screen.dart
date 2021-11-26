import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds a [UserList] for a [PaginatedUsersCubit].
///
/// For example implementations, see:
/// * [FollowersScreen]
/// * [FollowingScreen]
/// * [ListMembersScreen]
class PaginatedUsersScreen extends StatelessWidget {
  const PaginatedUsersScreen({
    required this.title,
    required this.noDataMessage,
    required this.errorMessage,
  });

  final String title;

  final String noDataMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PaginatedUsersCubit>();
    final state = cubit.state;

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: ScrollToStart(
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: cubit.loadMore,
            child: UserList(
              state.data?.toList() ?? [],
              beginSlivers: [
                HarpySliverAppBar(title: title, floating: true),
              ],
              endSlivers: [
                ...?state.mapOrNull(
                  loading: (_) => [const UserListLoadingSliver()],
                  loadingMore: (_) => [const LoadMoreIndicator()],
                  noData: (_) => [
                    SliverFillInfoMessage(primaryMessage: Text(noDataMessage)),
                  ],
                  error: (_) => [
                    SliverFillLoadingError(
                      message: Text(errorMessage),
                      onRetry: cubit.loadInitial,
                    ),
                  ],
                ),
                const SliverBottomPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
