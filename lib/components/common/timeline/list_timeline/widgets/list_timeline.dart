import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds the [TweetList] for the tweets in a list.
///
/// [listId] is used for the [PageStorageKey] of the list.
class ListTimeline extends StatelessWidget {
  const ListTimeline({
    @required this.listId,
    this.beginSlivers = const <Widget>[],
  });

  final String listId;

  final List<Widget> beginSlivers;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final ListTimelineBloc bloc = context.watch<ListTimelineBloc>();
    final ListTimelineState state = bloc.state;

    return ScrollToStart(
      child: LoadMoreListener(
        listen: state.enableRequestOlder,
        onLoadMore: () async {
          bloc.add(const RequestOlderListTimeline());
          await bloc.requestOlderCompleter.future;
        },
        child: TweetList(
          state.timelineTweets,
          key: PageStorageKey<String>('list_timeline_$listId'),
          enableScroll: state.enableScroll,
          beginSlivers: beginSlivers,
          endSlivers: <Widget>[
            if (state.showLoading)
              const SliverFillLoadingIndicator()
            else if (state.showNoResult)
              SliverFillLoadingError(
                message: const Text('no list tweets found'),
                onRetry: () => bloc.add(const RequestListTimeline()),
              )
            else if (state.showError)
              SliverFillLoadingError(
                message: const Text('error loading list tweets'),
                onRetry: () => bloc.add(const RequestListTimeline()),
              )
            else if (state.showLoadingOlder)
              const SliverBoxLoadingIndicator()
            else if (state.showReachedEnd)
              const SliverBoxInfoMessage(
                secondaryMessage: Text('no more list tweets available'),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
