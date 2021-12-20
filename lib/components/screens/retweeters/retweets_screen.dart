import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/retweeters/retweets/cubit/retweets_cubit.dart';
import 'package:provider/provider.dart';

class RetweetsScreen extends StatelessWidget {
  const RetweetsScreen({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cubit = context.watch<RetweetersCubit>();
    final state = cubit.state;

    return ScrollDirectionListener(
      child: ScrollToStart(
        child: UserList(
          state.data?.toList() ?? [],
          beginSlivers: [
            HarpySliverAppBar(
              title: title,
              floating: true,
            ),
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
                  message: Text('error searching users'),
                ),
              ],
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
