import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/common/misc/scroll_aware_floating_action_button.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

class UserTimeline extends StatefulWidget {
  const UserTimeline();

  @override
  _UserTimelineState createState() => _UserTimelineState();
}

class _UserTimelineState extends State<UserTimeline> {
  Widget _buildFloatingActionButton(
    BuildContext context,
    UserTimelineBloc bloc,
  ) {
    return FloatingActionButton(
      onPressed: () async {
        ScrollDirection.of(context).reset();
        bloc.add(const RequestUserTimeline());
      },
      child: const Icon(CupertinoIcons.refresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final UserTimelineBloc bloc = context.watch<UserTimelineBloc>();
    final UserTimelineState state = bloc.state;

    return ScrollToStart(
      child: LoadMoreListener(
        listen: state.enableRequestOlder,
        onLoadMore: () async {
          bloc.add(const RequestOlderUserTimeline());
          await bloc.requestOlderCompleter.future;
        },
        child: ScrollAwareFloatingActionButton(
          floatingActionButton: state is UserTimelineResult
              ? _buildFloatingActionButton(context, bloc)
              : null,
          child: TweetList(
            state.timelineTweets,
            key: const PageStorageKey<String>('user_timeline'),
            enableScroll: state.enableScroll,
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
