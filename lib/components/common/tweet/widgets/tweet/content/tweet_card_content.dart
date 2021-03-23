import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the content for a tweet.
class TweetCardContent extends StatelessWidget {
  const TweetCardContent(this.tweet);

  final TweetData tweet;

  bool _addBottomPadding(Widget child, List<Widget> content) {
    final List<Widget> filtered = content
        .where((Widget element) => element is! TweetTranslation)
        .toList();

    // tweet translation builds its own padding
    // don't add padding to last and second to last child
    return child is! TweetTranslation &&
        child != content.last &&
        child != filtered[filtered.length - 2];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> content = <Widget>[
      TweetTopRow(
        beginPadding: DefaultEdgeInsets.only(left: true, top: true),
        begin: <Widget>[
          if (tweet.isRetweet) ...<Widget>[
            TweetRetweetedRow(tweet),
            AnimatedContainer(
              duration: kLongAnimationDuration,
              height: defaultSmallPaddingValue,
            ),
          ],
          TweetAuthorRow(tweet.userData, createdAt: tweet.createdAt),
        ],
        end: TweetActionsButton(tweet, padding: DefaultEdgeInsets.all()),
      ),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.translatable)
        TweetTranslation(
          tweet,
          padding: EdgeInsets.only(
            top: !(tweet.hasMedia || tweet.hasQuote)
                ? defaultSmallPaddingValue
                : 0,
            bottom:
                tweet.hasMedia || tweet.hasQuote ? defaultSmallPaddingValue : 0,
          ),
        ),
      if (tweet.hasMedia) TweetMedia(tweet),
      if (tweet.hasQuote) TweetQuoteContent(tweet.quote),
      TweetActionRow(tweet),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => app<HarpyNavigator>().pushRepliesScreen(
        tweet: tweet,
      ),
      child: BlocProvider<TweetBloc>(
        create: (BuildContext content) => TweetBloc(tweet),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (Widget child in content) ...<Widget>[
              if (child == content.first || child == content.last)
                child
              else
                AnimatedPadding(
                  duration: kShortAnimationDuration,
                  padding: DefaultEdgeInsets.only(left: true, right: true),
                  child: child,
                ),
              if (_addBottomPadding(child, content))
                AnimatedContainer(
                  duration: kShortAnimationDuration,
                  height: defaultSmallPaddingValue,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
