import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/load_more_indicator.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/load_more_locked.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/following_followers/following/bloc/following_bloc.dart';
import 'package:harpy/components/following_followers/following/bloc/following_event.dart';
import 'package:harpy/components/user/widgets/user_list.dart';

/// Builds a [UserList] for the following users.
class FollowingList extends StatelessWidget {
  const FollowingList(this.bloc);

  final FollowingBloc bloc;

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: LoadMoreListener(
          listen: bloc.canLoadMore,
          onLoadMore: () async {
            bloc.add(const LoadFollowingUsers());
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
}
