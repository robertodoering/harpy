import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// A callback for actions on a timeline, such as refreshing or loading more
/// tweets for a timeline.
typedef BlocAction<T> = void Function(T);

/// The shared base for the [FollowingScreen] and the [FollowersScreen].
// todo: refactor similar to user search screen
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
  final Create<B> create;

  /// The scaffold title.
  final String title;

  /// The error message for the [LoadingDataError].
  final String errorMessage;

  /// The callback when tapping on the retry button for the [LoadingDataError].
  final BlocAction<B> loadUsers;

  /// Builds a [UserList] for the users.
  Widget _buildList(MediaQueryData mediaQuery, B bloc) {
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
            beginSlivers: <Widget>[
              HarpySliverAppBar(title: title, floating: true),
            ],
            endSlivers: <Widget>[
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
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return BlocProvider<B>(
      create: create,
      child: BlocBuilder<B, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          final B bloc = context.watch<B>();

          Widget child;
          bool scaffoldTitle = true;

          if (bloc.loadingInitialData || state is InitialState) {
            child = const Center(child: CircularProgressIndicator());
          } else if (bloc.showNoDataExists || bloc.showError) {
            child = LoadingDataError(
              message: Text(errorMessage),
              onRetry: () => loadUsers(bloc),
            );
          } else {
            scaffoldTitle = false;
            child = _buildList(mediaQuery, bloc);
          }

          return HarpyScaffold(
            title: scaffoldTitle ? title : null,
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
