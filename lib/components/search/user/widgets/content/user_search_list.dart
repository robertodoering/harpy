import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';
import 'package:harpy/components/search/user/widgets/content/user_search_app_bar.dart';
import 'package:harpy/components/user/widgets/user_list.dart';

/// Builds the [UserList] for the [UserSearchScreen].
class UserSearchList extends StatelessWidget {
  const UserSearchList();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final UserSearchBloc bloc = UserSearchBloc.of(context);

    final bool enableScroll =
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
                const SliverFillLoadingIndicator()
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
