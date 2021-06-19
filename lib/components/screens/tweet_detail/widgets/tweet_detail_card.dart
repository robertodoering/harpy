import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetDetailCard extends StatelessWidget {
  const TweetDetailCard();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RepliesBloc>();

    return SliverPadding(
      padding: DefaultEdgeInsets.all().copyWith(top: 0),
      sliver: SliverToBoxAdapter(
        child: BlocProvider(
          create: (_) => TweetBloc(bloc.tweet),
          child: Card(
            child: TweetCardContent(
              outerPadding: defaultPaddingValue,
              innerPadding: defaultSmallPaddingValue,
              config: _detailTweetCardConfig,
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
