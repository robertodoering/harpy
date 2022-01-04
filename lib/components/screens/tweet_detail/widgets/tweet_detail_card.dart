import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class TweetDetailCard extends StatelessWidget {
  const TweetDetailCard();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<RepliesCubit>();

    return SliverPadding(
      padding: config.edgeInsets.copyWith(top: 0),
      sliver: SliverToBoxAdapter(
        child: VisibilityChangeDetector(
          key: Key('${cubit.tweet.hashCode}_visibility'),
          child: BlocProvider(
            create: (_) => TweetBloc(cubit.tweet),
            child: Card(
              child: TweetCardContent(
                outerPadding: config.paddingValue,
                innerPadding: config.smallPaddingValue,
                config: _detailTweetCardConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final _detailTweetCardConfig = kDefaultTweetCardConfig.copyWith(
  elements: [
    ...kDefaultTweetCardConfig.elements,
    TweetCardElement.details,
  ],
);
