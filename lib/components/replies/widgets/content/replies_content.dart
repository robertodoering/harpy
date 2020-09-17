import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/replies/bloc/replies_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_card.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

/// Builds the content for the [RepliesScreen].
class RepliesContent extends StatelessWidget {
  const RepliesContent({
    @required this.bloc,
  });

  final RepliesBloc bloc;

  Widget _buildSliverAppBar() {
    return const HarpySliverAppBar(
      title: 'Replies',
      floating: true,
    );
  }

  Widget _buildRepliesTitle(ThemeData theme) {
    return SliverToBoxAdapter(
      child: ListCardAnimation(
        key: const Key('replies'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 40,
                child: Icon(Icons.reply, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Replies',
                  style: theme.textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoReplies(ThemeData theme) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ListCardAnimation(
        key: const Key('replies'),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'No replies found',
                style: theme.textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Text(
                'Only replies of the last 7 days can be retrieved.',
                style: theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepliesLoading() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: ListCardAnimation(
        key: Key('loading'),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: TweetList(
          bloc.replies,
          beginSlivers: <Widget>[
            _buildSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: TweetCard(bloc.tweet),
              ),
            ),
            if (bloc.state is LoadingRepliesState)
              _buildRepliesLoading()
            else if (bloc.replies.isNotEmpty)
              _buildRepliesTitle(theme)
            else if (bloc.noRepliesExists)
              _buildNoReplies(theme)
          ],
        ),
      ),
    );
  }
}
