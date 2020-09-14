import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/api/loading_data_error.dart';
import 'package:harpy/components/common/list/load_more_indicator.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/load_more_locked.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';
import 'package:harpy/components/user/widgets/user_list.dart';

/// A callback for actions on a timeline, such as refreshing or loading more
/// tweets for a timeline.
typedef BlocAction<T> = void Function(T);

/// The shared base for the [FollowingScreen] and the [FollowersScreen].
class FollowingFollowersScreen<B extends FollowingFollowersBloc>
    extends StatelessWidget {
  const FollowingFollowersScreen({
    @required this.userId,
    @required this.create,
    @required this.title,
    @required this.errorMessage,
    @required this.loadUsers,
  });

  /// The [userId] of the user whom to search the users for.
  final String userId;

  /// Builds the bloc for the [BlocProvider].
  final CreateBloc<B> create;

  /// The scaffold title.
  final String title;

  /// The error message for the [LoadingDataError].
  final String errorMessage;

  /// The callback when tapping on the retry button for the [LoadingDataError].
  final BlocAction<B> loadUsers;

  /// Builds a [UserList] for the users.
  Widget _buildList(B bloc) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: bloc.canLoadMore,
          onLoadMore: () async {
            loadUsers(bloc);
            await bloc.loadDataCompleter.future;
          },
          child: UserList(
            bloc.users,
            endSlivers: <Widget>[
              if (bloc.showLoadingMore)
                const LoadMoreIndicator()
              else if (bloc.lockRequests && bloc.hasNextPage)
                const LoadingMoreLocked(type: 'users'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: create,
      child: BlocBuilder<B, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          final B bloc = BlocProvider.of<B>(context);

          Widget child;

          if (bloc.loadingInitialData) {
            child = const Center(child: CircularProgressIndicator());
          } else if (bloc.showNoDataExists) {
            child = LoadingDataError(
              message: errorMessage,
              onTap: () => loadUsers(bloc),
            );
          } else {
            child = _buildList(bloc);
          }

          return HarpyScaffold(
            title: title,
            body: AnimatedSwitcher(
              duration: kShortAnimationDuration,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
