import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/widgets/default_padding/layout_padding.dart';
import 'package:provider/provider.dart';

class TweetDetailCard extends StatelessWidget {
  const TweetDetailCard();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RepliesBloc>();

    return SliverPadding(
      padding: DefaultEdgeInsets.all().copyWith(top: 0),
      sliver: SliverToBoxAdapter(
        // todo: build a detailed card here uwu
        child: TweetCard(bloc.tweet),
      ),
    );
  }
}
