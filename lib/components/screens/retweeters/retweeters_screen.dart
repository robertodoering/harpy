import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of users that retweeted a tweet
/// [tweetId].
class RetweetersScreen extends StatelessWidget {
  const RetweetersScreen({
    required this.tweetId,
  });

  /// The [tweetId] of the user whom to search the retweeters for.
  final String tweetId;

  static const route = 'retweeters';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RetweetersCubit(tweetId: tweetId),
      child: const ScrollDirectionListener(
        child: ScrollToStart(
          child: _Content(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RetweetersCubit>();
    final state = cubit.state;

    return HarpyScaffold(
      body: UserList(
        state.data?.toList() ?? [],
        beginSlivers: const [
          HarpySliverAppBar(title: 'retweeted by', floating: true),
        ],
        endSlivers: [
          ...?state.mapOrNull(
            loading: (_) => [const UserListLoadingSliver()],
            loadingMore: (_) => [const LoadMoreIndicator()],
            noData: (_) => const [
              SliverFillInfoMessage(
                primaryMessage: Text('no users found'),
              ),
            ],
            error: (_) => const [
              SliverFillLoadingError(
                message: Text('error loading retweeters'),
              ),
            ],
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}
