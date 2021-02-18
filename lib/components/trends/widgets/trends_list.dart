import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/trends/bloc/trends_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:intl/intl.dart';

class TrendsList extends StatelessWidget {
  final NumberFormat _numberFormat = NumberFormat.compact();

  Widget _buildTrendTile(Trend trend) {
    Widget subtitle;

    if (trend.tweetVolume != null) {
      subtitle = Text('${_numberFormat.format(trend.tweetVolume)} tweets');
    }

    return ListCardAnimation(
      key: ValueKey<int>(trend.hashCode),
      child: Card(
        child: ListTile(
          leading: const Icon(FeatherIcons.trendingUp, size: 18),
          title: Text(trend.name),
          subtitle: subtitle,
          onTap: () => app<HarpyNavigator>().pushTweetSearchScreen(
            initialSearchQuery: trend.name,
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index, List<Trend> trends) {
    if (index.isEven) {
      return _buildTrendTile(trends[index ~/ 2]);
    } else {
      return defaultSmallVerticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsBloc>(
      create: (_) => TrendsBloc()..add(const FindTrendsEvent.global()),
      child: Builder(
        builder: (BuildContext context) {
          final TrendsBloc bloc = context.watch<TrendsBloc>();
          final TrendsState state = bloc.state;

          if (state.isLoading) {
            return const SliverBoxLoadingIndicator();
          } else if (state.loadingFailed) {
            return const SliverBoxInfoMessage(
              secondaryMessage: Text('error requesting trends'),
            );
          } else if (state.hasTrends) {
            return SliverPadding(
              padding: DefaultEdgeInsets.only(
                left: true,
                right: true,
                bottom: true,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) => _itemBuilder(index, state.trends),
                  childCount: state.trends.length * 2 - 1,
                ),
              ),
            );
          } else {
            return const SliverBoxInfoMessage(
              secondaryMessage: Text('no trends exist'),
            );
          }
        },
      ),
    );
  }
}
