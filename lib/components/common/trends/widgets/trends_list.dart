import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:intl/intl.dart';

class TrendsList extends StatelessWidget {
  const TrendsList();

  Widget _buildTrendCard(Trend trend) {
    final numberFormat = NumberFormat.compact();

    Widget? subtitle;

    if (trend.tweetVolume != null) {
      subtitle = Text('${numberFormat.format(trend.tweetVolume)} tweets');
    }

    return ListCardAnimation(
      key: ValueKey<int>(trend.hashCode),
      child: HarpyListCard(
        leading: const Icon(FeatherIcons.trendingUp, size: 18),
        title: Text(trend.name!),
        subtitle: subtitle,
        onTap: () => app<HarpyNavigator>().pushTweetSearchScreen(
          initialSearchQuery: trend.name,
        ),
      ),
    );
  }

  Widget _itemBuilder(int index, BuiltList<Trend> trends) {
    if (index.isEven) {
      return _buildTrendCard(trends[index ~/ 2]);
    } else {
      return verticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TrendsCubit>();
    final state = cubit.state;

    return state.map(
      data: (value) => SliverPadding(
        padding: config.edgeInsetsOnly(
          left: true,
          right: true,
          bottom: true,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => _itemBuilder(index, value.trends),
            childCount: value.trends.length * 2 - 1,
          ),
        ),
      ),
      loading: (_) => const TrendsListLoadingSliver(),
      error: (_) => const SliverBoxInfoMessage(
        secondaryMessage: Text('error requesting trends'),
      ),
      initial: (_) => const SliverBoxInfoMessage(
        secondaryMessage: Text('no trends exist'),
      ),
    );
  }
}
