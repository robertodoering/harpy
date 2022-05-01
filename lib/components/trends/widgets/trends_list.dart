import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class TrendsList extends ConsumerWidget {
  const TrendsList();

  Widget _itemBuilder(int index, BuiltList<Trend> trends) {
    return index.isEven ? TrendCard(trend: trends[index ~/ 2]) : verticalSpacer;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return ref.watch(trendsProvider).when(
          loading: () => const TrendsListLoadingSliver(),
          data: (state) => state.trends.isNotEmpty
              ? SliverPadding(
                  padding: display.edgeInsets.copyWith(top: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => _itemBuilder(index, state.trends),
                      childCount: state.trends.length * 2 - 1,
                    ),
                  ),
                )
              : const SliverFillInfoMessage(
                  secondaryMessage: Text('no trends'),
                ),
          error: (_, __) => const SliverFillInfoMessage(
            secondaryMessage: Text('error requesting trends'),
          ),
        );
  }
}
