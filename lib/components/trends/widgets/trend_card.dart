import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:intl/intl.dart';

class TrendCard extends ConsumerWidget {
  const TrendCard({
    required this.trend,
  });

  final Trend trend;

  static final _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return VisibilityChangeListener(
      detectorKey: ValueKey(trend.hashCode),
      child: ListCardAnimation(
        child: HarpyListCard(
          leading: const Icon(FeatherIcons.trendingUp, size: 18),
          title: Text(trend.name ?? ''),
          subtitle: trend.tweetVolume != null
              ? Text('${_numberFormat.format(trend.tweetVolume)} tweets')
              : null,
          // TODO: go to tweet search with trend as query
          onTap: () {},
        ),
      ),
    );
  }
}
