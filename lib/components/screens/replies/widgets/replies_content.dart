import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds the content for the [RepliesScreen].
class RepliesContent extends StatelessWidget {
  const RepliesContent({
    required this.bloc,
  });

  final RepliesBloc bloc;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: TweetList(
          bloc.replies,
          beginSlivers: <Widget>[
            const HarpySliverAppBar(
              title: 'replies',
              floating: true,
            ),
            SliverPadding(
              padding: DefaultEdgeInsets.all(),
              sliver: SliverToBoxAdapter(
                child: TweetCard(bloc.tweet!),
              ),
            ),
            if (bloc.state is LoadingRepliesState)
              const ListLoadingSliver()
            else if (bloc.replies.isNotEmpty)
              const RepliesListTitle()
            else if (bloc.noRepliesExists)
              const NoRepliesFound(),
          ],
          endSlivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            )
          ],
        ),
      ),
    );
  }
}
