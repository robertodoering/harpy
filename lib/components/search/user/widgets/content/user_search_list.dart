import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/api/loading_data_error.dart';
import 'package:harpy/components/common/list/load_more_indicator.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
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
    final ThemeData theme = Theme.of(context);
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
                const SliverFillRemaining(
                  child: FadeAnimation(
                    duration: kShortAnimationDuration,
                    curve: Curves.easeInOut,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (bloc.state is LoadingPaginatedData)
                const LoadMoreIndicator(),
              if (bloc.showError)
                SliverFillRemaining(
                  child: FadeAnimation(
                    duration: kShortAnimationDuration,
                    curve: Curves.easeInOut,
                    child: LoadingDataError(
                      message: 'Error loading users',
                      onTap: () => bloc.add(SearchUsers(bloc.lastQuery)),
                    ),
                  ),
                )
              else if (bloc.showNoDataExists)
                SliverFillRemaining(
                  child: FadeAnimation(
                    duration: kShortAnimationDuration,
                    curve: Curves.easeInOut,
                    child: Center(
                      child: Text(
                        'No users found',
                        style: theme.textTheme.headline6,
                      ),
                    ),
                  ),
                ),
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
