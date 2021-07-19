import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Displays global trends after typing `#`.
class ComposeTweetTrends extends StatelessWidget {
  const ComposeTweetTrends({
    required this.controller,
  });

  final ComposeTextController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsBloc>(
      create: (context) => TrendsBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.watch<TrendsBloc>();
          final state = bloc.state;

          Widget? child;

          if (state.hasTrends) {
            child = TrendSuggestions(controller: controller);
          }

          return ComposeTweetSuggestions(
            controller: controller,
            selectionRegExp: hashtagStartRegex,
            onSearch: (hashtag) {
              if (state is TrendsInitial) {
                bloc.add(const FindTrendsEvent());
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}

class TrendSuggestions extends StatelessWidget {
  const TrendSuggestions({
    required this.controller,
  });

  final ComposeTextController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<TrendsBloc>();
    final state = bloc.state;

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: config.edgeInsets.copyWith(
            bottom: config.smallPaddingValue / 2,
          ),
          child: Text(
            'worldwide trends',
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (Trend trend in state.hashtags)
              HarpyButton.flat(
                padding: EdgeInsets.symmetric(
                  vertical: config.smallPaddingValue / 2,
                  horizontal: config.paddingValue,
                ),
                text: Text(
                  trend.name!,
                  style: theme.textTheme.bodyText1!.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                onTap: () => controller!.replaceSelection('${trend.name} '),
              ),
          ],
        )
      ],
    );
  }
}
