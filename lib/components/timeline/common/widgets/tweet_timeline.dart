import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/list/load_more_indicator.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/load_more_locked.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/components/timeline/common/widgets/no_timeline_tweets.dart';
import 'package:harpy/components/timeline/common/widgets/timeline_loading.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

/// A callback for actions on a timeline, such as refreshing or loading more
/// tweets for a timeline.
typedef OnTimelineAction<T> = Future<void> Function(T);

/// Builds the [TweetList] for a [TimelineBloc].
class TweetTimeline<T extends TimelineBloc> extends StatelessWidget {
  const TweetTimeline({
    @required this.onRefresh,
    @required this.onLoadMore,
    this.headerSlivers = const <Widget>[],
    this.refreshIndicatorDisplacement = 40,
  });

  /// The callback for a [RefreshIndicator] for the [TweetList].
  final OnTimelineAction<T> onRefresh;

  /// The callback for a [LoadMoreList] for the [TweetList].
  final OnTimelineAction<T> onLoadMore;

  /// Slivers built at the beginning of the [CustomScrollView] in the
  /// [TweetList].
  final List<Widget> headerSlivers;

  /// The [RefreshIndicator.displacement].
  final double refreshIndicatorDisplacement;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, TimelineState>(
      builder: (BuildContext context, TimelineState state) {
        final T bloc = BlocProvider.of<T>(context);

        Widget timelineInfo;

        if (bloc.showLoading) {
          timelineInfo = const TimelineLoading();
        } else if (state is NoTweetsFoundState || bloc.showFailed) {
          timelineInfo = NoTimelineTweets<T>(bloc, onRefresh: onRefresh);
        }

        return LoadMoreListener(
          listen: bloc.enableRequestMore,
          onLoadMore: () => onLoadMore(bloc),
          child: ScrollToStart(
            child: RefreshIndicator(
              displacement: refreshIndicatorDisplacement,
              onRefresh: () => onRefresh(bloc),
              child: TweetList(
                bloc.tweets,
                enableScroll: !bloc.showLoading && !bloc.showFailed,
                beginSlivers: <Widget>[
                  ...headerSlivers,
                  if (timelineInfo != null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AnimatedSwitcher(
                        duration: kShortAnimationDuration,
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: timelineInfo,
                      ),
                    ),
                ],
                endSlivers: <Widget>[
                  if (state is RequestingMoreState)
                    const LoadMoreIndicator()
                  else if (state is ShowingTimelineState &&
                      bloc.lockRequestMore)
                    const LoadingMoreLocked(type: 'Tweets'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
