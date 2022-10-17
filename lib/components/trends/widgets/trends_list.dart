import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TrendsList extends ConsumerWidget {
  const TrendsList();

  Widget _itemBuilder(int index, BuiltList<Trend> trends) {
    return index.isEven
        ? TrendCard(trend: trends[index ~/ 2])
        : VerticalSpacer.normal;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RbyAnimatedSwitcher.sliver(
      child: ref.watch(trendsProvider).when(
            loading: () => const TrendsListLoadingSliver(),
            data: (trends) => trends.isNotEmpty
                ? SliverPadding(
                    padding: theme.spacing.edgeInsets.copyWith(top: 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) => _itemBuilder(index, trends),
                        childCount: trends.length * 2 - 1,
                      ),
                    ),
                  )
                : const SliverFillInfoMessage(
                    secondaryMessage: Text('no trends'),
                  ),
            error: (_, __) => const SliverFillInfoMessage(
              secondaryMessage: Text('error requesting trends'),
            ),
          ),
    );
  }
}
