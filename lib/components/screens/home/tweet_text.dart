import 'dart:core';

import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';

class TweetText extends StatelessWidget {
  final Tweet tweet;

  const TweetText(this.tweet);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    var twitterLinks = TweetLinks(tweet);

    TwitterLinkModel nextLink;
    int textStart = 0;

    do {
      nextLink = twitterLinks.getNext();
      int textEnd;

      if (nextLink != null) {
        textEnd = nextLink.startIndex;
      } else {
        textEnd = tweet.text.length;
      }

      print("text start: $textStart, end: $textEnd");
      print("link start: ${nextLink?.startIndex}, end: ${nextLink?.endIndex}");

      // text
      if (textStart < textEnd) {
        textSpans.add(TextSpan(
          text: tweet.text.substring(textStart, textEnd),
          style: Theme.of(context).textTheme.body1,
        ));
      }

      // link
      if (nextLink != null) {
        textSpans.add(TextSpan(
          text: nextLink.displayUrl,
          style: Theme.of(context)
              .textTheme
              .body1 // todo: custom color (logged in user color?)
              .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
        ));

        textStart = nextLink.endIndex + 1;
      }
    } while (nextLink != null);

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class TweetLinks {
  List<TwitterLinkModel> links = [];

  void _addLink(TwitterLinkModel link) {
    for (int i = 0; i < links.length; i++) {
      if (link.startIndex < links[i].startIndex) {
        links.insert(i, link);
        return;
      }
    }

    links.add(link);
  }

  TweetLinks(Tweet tweet) {
    for (var hashtag in tweet.entity.hashtags) {
      var link = TwitterLinkModel(
        hashtag.indices[0],
        hashtag.indices[1],
        hashtag.text, // todo: as url
        "#${hashtag.text}",
      );
      _addLink(link);
    }

    for (var url in tweet.entity.urls) {
      var link = TwitterLinkModel(
        url.indices[0],
        url.indices[1],
        url.expandedUrl,
        url.displayUrl,
      );
      _addLink(link);
    }

    for (var userMention in tweet.entity.userMentions) {
      var link = TwitterLinkModel(
        userMention.indices[0],
        userMention.indices[1],
        userMention.screenName, // todo: as url
        "@${userMention.screenName}",
      );
      _addLink(link);
    }
  }

  TwitterLinkModel getNext() {
    return links.isNotEmpty ? links.removeAt(0) : null;
  }
}

class TwitterLinkModel {
  final int startIndex;
  final int endIndex;
  final String url;
  final String displayUrl;

  const TwitterLinkModel(
    this.startIndex,
    this.endIndex,
    this.url,
    this.displayUrl,
  );

  @override
  String toString() {
    return 'TwitterLink{startIndex: $startIndex, endIndex: $endIndex, url: $url, displayUrl: $displayUrl}';
  }
}

enum LinkType {
  hashtag,
  url,
}
