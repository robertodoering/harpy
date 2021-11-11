import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/common/bloc/likes_retweets_bloc.dart';
import 'package:provider/provider.dart';

/// A callback for actions on a timeline, such as refreshing or loading more
/// tweets for a timeline.
typedef BlocAction<T> = void Function(T);

/// The shared base for the [LikesScreen] and the [RetweetsScreen].
class LikesRetweetsScreen<B extends LikesRetweetsBloc> extends StatelessWidget {
  const LikesRetweetsScreen({
    required this.userId,
    required this.create,
    required this.title,
    required this.errorMessage,
    required this.loadUsers,
  });

  /// The [userId] of the user whom to search the users for.
  final String? userId;

  /// Builds the bloc for the [BlocProvider].
  final Create<B> create;

  /// The scaffold title.
  final String title;

  /// The error message for the [LoadingDataError].
  final String errorMessage;

  /// The callback when tapping on the retry button for the [LoadingDataError].
  final BlocAction<B> loadUsers;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
//TODO add in similar functionality to the tweet filter in user profiles to introduce sorting in lists
    return BlocProvider<B>(
      create: create,
      child: BlocBuilder<B, PaginatedState>(
        builder: (context, state) {
          final bloc = context.watch<B>();
          return HarpyScaffold(
            body: ScrollDirectionListener(
              child: ScrollToStart(
                child: UserList(
                  bloc.users,
                  beginSlivers: [
                    HarpySliverAppBar(title: title, floating: true),
                  ],
                  endSlivers: [
                    if (bloc.loadingInitialData ||
                        state is InitialPaginatedState)
                      const UserListLoadingSliver()
                    else if (bloc.showNoDataExists || bloc.showError)
                      SliverFillLoadingError(
                        message: Text(errorMessage),
                        onRetry: () => loadUsers(bloc),
                      ),
                    if (bloc.showLoadingMore)
                      const LoadMoreIndicator()
                    else if (bloc.lockRequests && bloc.hasNextPage)
                      const LoadingMoreLocked(type: 'users'),
                    SliverToBoxAdapter(
                      child: SizedBox(height: mediaQuery.padding.bottom),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
