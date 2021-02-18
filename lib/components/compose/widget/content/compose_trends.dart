import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/compose/widget/content/compose_suggestions.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/trends/bloc/trends_bloc.dart';
import 'package:harpy/core/regex/twitter_regex.dart';

/// Displays global trends after typing `#`.
class ComposeTweetTrends extends StatelessWidget {
  const ComposeTweetTrends({
    @required this.controller,
  });

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsBloc>(
      create: (BuildContext context) => TrendsBloc(),
      child: Builder(
        builder: (BuildContext context) {
          final TrendsBloc bloc = context.watch<TrendsBloc>();
          final TrendsState state = bloc.state;

          Widget child;

          if (state.hasTrends) {
            child = TrendSuggestions(controller: controller);
          }

          return ComposeTweetSuggestions(
            controller: controller,
            selectionRegExp: hashtagStartRegex,
            onSearch: (String hashtag) {
              if (state is TrendsInitial) {
                bloc.add(const FindTrendsEvent.global());
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
    @required this.controller,
  });

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TrendsBloc bloc = context.watch<TrendsBloc>();
    final TrendsState state = bloc.state;

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: DefaultEdgeInsets.all().copyWith(
            bottom: defaultSmallPaddingValue / 2,
          ),
          child: Text(
            'worldwide trends',
            style: theme.textTheme.subtitle1.copyWith(
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
                  vertical: defaultSmallPaddingValue / 2,
                  horizontal: defaultPaddingValue,
                ),
                text: Text(
                  trend.name,
                  style: theme.textTheme.bodyText1.copyWith(
                    color: theme.accentColor,
                  ),
                ),
                onTap: () => controller.replaceSelection('${trend.name} '),
              ),
          ],
        )
      ],
    );
  }
}
