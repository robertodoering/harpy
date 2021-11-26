import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class TweetSearchList extends StatelessWidget {
  const TweetSearchList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TweetSearchCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: TweetList(
          state.tweets.toList(),
          enableScroll: state.hasData,
          beginSlivers: [TweetSearchAppBar(text: state.query)],
          endSlivers: [
            ...?state.mapOrNull(
              loading: (_) => [const TweetListLoadingSliver()],
              noData: (_) => [
                const SliverFillInfoMessage(
                  primaryMessage: Text('no tweets found'),
                  secondaryMessage: Text(
                    'only tweets of the last 7 days can be retrieved',
                  ),
                ),
              ],
              error: (_) => [
                SliverFillLoadingError(
                  message: const Text('error searching tweets'),
                  onRetry: () => cubit.search(
                    customQuery: state.query,
                    filter: state.filter,
                  ),
                ),
              ],
            ),
            const SliverBottomPadding(),
          ],
        ),
      ),
    );
  }
}
