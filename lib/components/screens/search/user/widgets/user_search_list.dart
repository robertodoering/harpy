import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds the [UserList] for the [UserSearchScreen].
class UserSearchList extends StatelessWidget {
  const UserSearchList();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bloc = UserSearchBloc.of(context);

    final enableScroll =
        !bloc.loadingInitialData && !bloc.showError && !bloc.showNoDataExists;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: bloc.canLoadMore,
          onLoadMore: () async => bloc.add(SearchUsers(bloc.lastQuery)),
          child: UserList(
            bloc.users,
            enableScroll: enableScroll,
            beginSlivers: const <Widget>[
              UserSearchAppBar(),
            ],
            endSlivers: <Widget>[
              if (bloc.loadingInitialData)
                const UserListLoadingSliver()
              else if (bloc.state is LoadingPaginatedData)
                const SliverBoxLoadingIndicator(),
              if (bloc.showError)
                SliverFillLoadingError(
                  message: const Text('error searching users'),
                  onRetry: () => bloc.add(SearchUsers(bloc.lastQuery)),
                )
              else if (bloc.showNoDataExists)
                const SliverFillInfoMessage(
                    primaryMessage: Text('no users found')),
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
