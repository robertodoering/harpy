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

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsCubit>(
      create: (context) => TrendsCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.watch<TrendsCubit>();
          final state = cubit.state;

          Widget? child;

          if (state.hasData) {
            child = TrendSuggestions(controller: controller);
          }

          return ComposeTweetSuggestions(
            controller: controller,
            selectionRegExp: hashtagStartRegex,
            onSearch: (hashtag) {
              if (state.isInitial) {
                cubit.findTrends();
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

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TrendsCubit>();
    final state = cubit.state;

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
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
          children: [
            for (final trend in state.hashtags)
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
                onTap: () => controller.replaceSelection('${trend.name} '),
              ),
          ],
        )
      ],
    );
  }
}
