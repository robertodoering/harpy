import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/like_sort_by_model.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// The shared base for the [LikesScreen] and the [RetweetsScreen].
class LikesRetweetsScreen extends StatelessWidget {
  const LikesRetweetsScreen({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // TODO make the cubit type dynamic to determine which loadUser logic to user
    final cubit = context.watch<RetweetsCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: UserList(
          state.data?.users.toList() ?? [],
          beginSlivers: [
            HarpySliverAppBar(
              title: title,
              floating: true,
              actions: const [_SortButton()],
            ),
          ],
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
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<UserListSortByModel>();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: HarpyButton.raised(
        backgroundColor: theme.canvasColor.withOpacity(.4),
        elevation: 0,
        padding: const EdgeInsets.all(12),
        icon: cubit.value != ListSortBy.empty
            ? Icon(Icons.sort, color: theme.colorScheme.secondary)
            : const Icon(Icons.sort_outlined),
        onTap: Scaffold.of(context).openEndDrawer,
      ),
    );
  }
}
