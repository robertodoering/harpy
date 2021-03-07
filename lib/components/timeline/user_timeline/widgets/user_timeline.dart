import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/common/misc/custom_refresh_indicator.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/components/user_profile/widgets/content/user_profile_app_bar.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final UserTimelineBloc bloc = context.watch<UserTimelineBloc>();
    final UserTimelineState state = bloc.state;

    final double appBarHeight = min(200, mediaQuery.size.height * .25);

    return ScrollToStart(
      child: CustomRefreshIndicator(
        offset: mediaQuery.padding.top + appBarHeight,
        onRefresh: () async {
          ScrollDirection.of(context).reset();
          bloc.add(const RequestUserTimeline());
          await bloc.requestTimelineCompleter.future;
        },
        child: LoadMoreListener(
          listen: state.enableRequestOlder,
          onLoadMore: () async {
            bloc.add(const RequestOlderUserTimeline());
            await bloc.requestOlderCompleter.future;
          },
          child: TweetList(
            state.timelineTweets,
            enableScroll: state.enableScroll,
            beginSlivers: const <Widget>[
              UserProfileAppBar(),
              UserProfileHeader(),
            ],
            endSlivers: <Widget>[
              if (state.showInitialLoading)
                const SliverFillLoadingIndicator()
              else if (state.showNoTweetsFound)
                SliverFillLoadingError(
                  message: const Text('no tweets found'),
                  onRetry: () => bloc.add(const RequestUserTimeline()),
                )
              else if (state.showTimelineError)
                SliverFillLoadingError(
                  message: const Text('error loading tweets'),
                  onRetry: () => bloc.add(const RequestUserTimeline()),
                )
              else if (state.showLoadingOlder)
                const SliverBoxLoadingIndicator()
              else if (state.showReachedEnd)
                const SliverBoxInfoMessage(
                  secondaryMessage: Text('no more tweets available'),
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
