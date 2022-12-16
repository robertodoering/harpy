import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Builds a [LegacyUserList] for a [PaginatedUsersNotifier].
///
/// For example implementations, see:
/// * [FollowersPage]
/// * [FollowingPage]
/// * [ListMembersPage]
class PaginatedUsersPage extends ConsumerWidget {
  const PaginatedUsersPage({
    required this.provider,
    required this.title,
    required this.noDataMessage,
    required this.errorMessage,
  });

  final AutoDisposeStateNotifierProvider<PaginatedUsersNotifier,
      PaginatedState<BuiltList<UserData>>> provider;

  final String title;
  final String noDataMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: notifier.loadMore,
            child: LegacyUserList(
              state.data?.toList() ?? [],
              beginSlivers: [HarpySliverAppBar(title: Text(title))],
              endSlivers: [
                ...?state.mapOrNull(
                  loading: (_) => [const UserListLoadingSliver()],
                  loadingMore: (_) => [
                    const SliverLoadingIndicator(),
                    VerticalSpacer.normalSliver,
                  ],
                  noData: (_) => [
                    SliverFillInfoMessage(
                      secondaryMessage: Text(noDataMessage),
                    ),
                  ],
                  error: (_) => [
                    SliverFillLoadingError(
                      message: Text(errorMessage),
                      onRetry: notifier.loadInitial,
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
