import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/widget/content/compose_suggestions.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/trends/bloc/trends_bloc.dart';
import 'package:harpy/components/trends/bloc/trends_event.dart';
import 'package:harpy/components/trends/bloc/trends_state.dart';

/// Displays global trends after typing `#`.
class ComposeTweetTrends extends StatelessWidget {
  const ComposeTweetTrends(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsBloc>(
      create: (BuildContext context) => TrendsBloc(),
      child: BlocBuilder<TrendsBloc, TrendsState>(
        builder: (BuildContext context, TrendsState state) {
          final TrendsBloc trendsBloc = TrendsBloc.of(context);

          Widget child;

          if (trendsBloc.hasTrends) {
            child = ListView(
              padding: EdgeInsets.all(defaultSmallPaddingValue),
              shrinkWrap: true,
              children: trendsBloc.trends.first.trends
                  .map((Trend trend) => Text(trend.name))
                  .toList(),
            );
          }

          return ComposeTweetSuggestions(
            bloc,
            controller: controller,
            identifier: '#',
            onSearch: (String query) {
              if (state is! RequestingTrendsState && !trendsBloc.hasTrends) {
                trendsBloc.add(const FindTrendsEvent.global());
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
