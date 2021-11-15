import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:provider/provider.dart';

/// The shared base for the [LikesScreen] and the [RetweetsScreen].
class LikesRetweetsScreen extends StatelessWidget {
  const LikesRetweetsScreen({
    required this.title,
  });

  /// The [tweetId] of the user whom to search the users for.
  final String title;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // TODO make the cubit type/cubit modular to determine which loadUser logic to user
    final cubit = context.watch<RetweetsCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: UserList(
          state.data?.users.toList() ?? [],
          beginSlivers: [
            HarpySliverAppBar(title: title, floating: true),
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
