import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/action_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/retweeted_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/translation.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/tweet_tile_quote_content.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds the content for a tweet.
class TweetCardContent extends StatelessWidget {
  const TweetCardContent(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      if (tweet.isRetweet) TweetRetweetedRow(tweet),
      TweetAuthorRow(tweet),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.translatable) TweetTranslation(tweet),
      if (tweet.hasMedia) TweetMedia(tweet),
      if (tweet.hasQuote) TweetQuoteContent(tweet.quote),
      TweetActionRow(tweet),
    ];

    return BlocProvider<TweetBloc>(
      create: (BuildContext content) => TweetBloc(tweet),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (Widget child in content) ...<Widget>[
              child,
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
