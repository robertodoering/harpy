import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline();

  Widget _buildFloatingActionButton(
    BuildContext context,
    UserTimelineBloc bloc,
  ) {
    return FloatingActionButton(
      onPressed: () async {
        ScrollDirection.of(context)!.reset!();
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
