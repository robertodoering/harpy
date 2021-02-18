import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

import 'content/compose_parent_tweet_card.dart';
import 'content/compose_tweet_card.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({
    this.inReplyToStatus,
    this.quotedTweet,
  }) : assert(inReplyToStatus == null || quotedTweet == null);

  /// The tweet that the user is replying to.
  final TweetData inReplyToStatus;

  /// The tweet that the user is quoting (aka retweeting with quote).
  final TweetData quotedTweet;

  static const String route = 'compose_screen';

  Widget _buildComposeCardWithReply(MediaQueryData mediaQuery) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * .6,
          ),
          child: const ComposeTweetCard(),
        ),
        defaultVerticalSpacer,
        if (inReplyToStatus != null)
          ComposeParentTweetCard(
            parentTweet: inReplyToStatus,
            text: 'replying to',
          )
        else if (quotedTweet != null)
          ComposeParentTweetCard(
            parentTweet: quotedTweet,
            text: 'quoting',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    Widget child;

    if (inReplyToStatus != null || quotedTweet != null) {
      child = _buildComposeCardWithReply(mediaQuery);
    } else {
      child = const ComposeTweetCard();
    }

    return BlocProvider<ComposeBloc>(
      create: (BuildContext context) => ComposeBloc(
        inReplyToStatus: inReplyToStatus,
        quotedTweet: quotedTweet,
      ),
      child: HarpyScaffold(
        title: 'compose tweet',
        buildSafeArea: true,
        body: Padding(
          padding: DefaultEdgeInsets.all(),
          child: child,
        ),
      ),
    );
  }
}
