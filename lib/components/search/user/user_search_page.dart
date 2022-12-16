import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserSearchPage extends ConsumerWidget {
  const UserSearchPage();

  static const name = 'user_search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSearchProvider);
    final notifier = ref.watch(userSearchProvider.notifier);

    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: notifier.loadMore,
            child: LegacyUserList(
              state.data?.users.toList() ?? [],
              beginSlivers: [
                SearchAppBar(
                  onSubmitted: notifier.search,
                  onClear: notifier.clear,
                  autofocus: true,
                ),
              ],
              endSlivers: [
                ...?state.mapOrNull(
                  loading: (_) => const [UserListLoadingSliver()],
                  loadingMore: (_) => const [
                    SliverLoadingIndicator(),
                    VerticalSpacer.normalSliver,
                  ],
                  noData: (_) => const [
                    SliverFillInfoMessage(
                      secondaryMessage: Text('no users found'),
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
      ),
    );
  }
}
