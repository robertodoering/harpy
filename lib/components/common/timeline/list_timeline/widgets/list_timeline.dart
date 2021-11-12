import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_list_data.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

/// Builds the [TweetList] for the tweets in a list.
///
/// [listId] is used for the [PageStorageKey] of the list.
class ListTimeline extends StatelessWidget {
  const ListTimeline({
    required this.listId,
    this.name,
    this.beginSlivers = const [],
  });

  final String listId;
  final String? name;
  final List<Widget> beginSlivers;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bloc = context.watch<ListTimelineBloc>();
    final state = bloc.state;

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
          beginSlivers: [
            ...beginSlivers,
            if (state.hasTweets) _TopRow(list: list),
          ],
          endSlivers: [
            if (state.showLoading)
              const TweetListLoadingSliver()
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

class _TopRow extends StatelessWidget {
  const _TopRow({
    this.list,
  });
  final TwitterListData? list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final bloc = context.watch<ListTimelineBloc>();

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsOnly(
          top: true,
          left: true,
          right: true,
        ),
        child: Row(
          children: [
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: const Icon(CupertinoIcons.refresh),
              onTap: () => bloc.add(const RequestListTimeline()),
            ),
            defaultHorizontalSpacer,
            if(list != null)
              HarpyButton.raised(
                padding: config.edgeInsets,
                elevation: 0,
                backgroundColor: theme.cardTheme.color,
                icon: const Icon(CupertinoIcons.info),
                onTap: () => 
                  app<HarpyNavigator>().pushListMembersScreen(list: list!),
              ),
          ],
        ),
      ),
    );
  }
}
