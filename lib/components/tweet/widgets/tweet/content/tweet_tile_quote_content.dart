import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/translation.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the content for a tweet quote.
class TweetQuoteContent extends StatelessWidget {
  const TweetQuoteContent(this.tweet);

  final TweetData tweet;

  void _onUserMentionTap(UserMention userMention) {
    if (userMention.screenName != null) {
      app<HarpyNavigator>().pushUserProfile(screenName: userMention.screenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      TweetAuthorRow(
        tweet,
        avatarRadius: 14,
        fontSizeDelta: -2,
        iconSize: 14,
      ),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          style: theme.textTheme.bodyText2.apply(fontSizeDelta: -2),
          urlToIgnore: tweet.quotedStatusUrl,
          onUserMentionTap: _onUserMentionTap,
        ),
      if (tweet.translatable) TweetTranslation(tweet, fontSizeDelta: -2),
      if (tweet.hasMedia) TweetMedia(tweet),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),
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
    );
  }
}
