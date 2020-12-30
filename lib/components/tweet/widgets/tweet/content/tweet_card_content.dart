import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/action_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/actions_button.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/retweeted_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/translation.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/tweet_card_quote_content.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

/// Builds the content for a tweet.
class TweetCardContent extends StatelessWidget {
  const TweetCardContent(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final List<Widget> content = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (tweet.isRetweet) TweetRetweetedRow(tweet),
                TweetAuthorRow(tweet.userData, createdAt: tweet.createdAt),
              ],
            ),
          ),
          TweetActionsButton(),
        ],
      ),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.translatable) TweetTranslation(tweet),
      if (tweet.hasMedia) TweetMedia(tweet),
      if (tweet.hasQuote) TweetQuoteContent(tweet.quote),
      TweetActionRow(tweet),
    ];

    return BlocProvider<TweetBloc>(
      create: (BuildContext content) => TweetBloc(tweet),
      child: AnimatedPadding(
        duration: kShortAnimationDuration,
        padding: DefaultEdgeInsets.only(top: true, left: true, right: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (Widget child in content) ...<Widget>[
              child,
              if (child == content.last)
                AnimatedContainer(
                  duration: kLongAnimationDuration,
                  height: defaultPaddingValue,
                )
              else
                AnimatedContainer(
                  duration: kLongAnimationDuration,
                  height: defaultPaddingValue / 2,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
