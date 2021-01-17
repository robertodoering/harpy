import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_loading_sliver.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/replies/bloc/replies_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/components/replies/widgets/content/no_replies_found.dart';
import 'package:harpy/components/replies/widgets/content/replies_list_title.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_card.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

/// Builds the content for the [RepliesScreen].
class RepliesContent extends StatelessWidget {
  const RepliesContent({
    @required this.bloc,
  });

  final RepliesBloc bloc;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: TweetList(
          bloc.replies,
          beginSlivers: <Widget>[
            const HarpySliverAppBar(
              title: 'Replies',
              floating: true,
            ),
            SliverPadding(
              padding: DefaultEdgeInsets.all(),
              sliver: SliverToBoxAdapter(
                child: TweetCard(bloc.tweet),
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
