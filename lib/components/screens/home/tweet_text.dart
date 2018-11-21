import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/utils/url_launcher.dart';

class TweetText extends StatefulWidget {
  final Tweet tweet;

  const TweetText(this.tweet);

  @override
  TweetTextState createState() {
    return new TweetTextState();
  }
}

class TweetTextState extends State<TweetText> {
  List<GestureRecognizer> gestureRecognizer = [];

  @override
  void dispose() {
    super.dispose();
    gestureRecognizer.forEach((recognizer) => recognizer.dispose());
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    var twitterLinks = TweetLinks(widget.tweet);

    TwitterLinkModel nextLink;
    int textStart = 0;

    do {
      nextLink = twitterLinks.getNext();
      int textEnd;

      if (nextLink != null) {
        textEnd = nextLink.startIndex;
      } else {
        textEnd = widget.tweet.text.length;
      }

      // text
      if (textStart < textEnd) {
        textSpans.add(TextSpan(
          text: widget.tweet.text.substring(textStart, textEnd),
          style: Theme.of(context).textTheme.body1,
        ));
      }

      // link
      if (nextLink != null) {
        GestureRecognizer recognizer = null;
        if (nextLink.type == LinkType.url) {
          String url = nextLink.url;

          recognizer = TapGestureRecognizer()..onTap = () => launchUrl(url);
          gestureRecognizer.add(recognizer);
        }

        textSpans.add(TextSpan(
          text: "${nextLink.displayUrl} ",
          style: Theme.of(context)
              .textTheme
              .body1 // todo: custom color (logged in user color?)
              .copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
          recognizer: recognizer,
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
        hashtag.text, // todo: make request for hashtag
        "#${hashtag.text}",
        LinkType.hashtag,
      );
      _addLink(link);
    }

    for (var url in tweet.entity.urls) {
      var link = TwitterLinkModel(
        url.indices[0],
        url.indices[1],
        url.expandedUrl, // todo: open link in browser
        url.displayUrl,
        LinkType.url,
      );
      _addLink(link);
    }

    for (var userMention in tweet.entity.userMentions) {
      var link = TwitterLinkModel(
        userMention.indices[0],
        userMention.indices[1],
        userMention.screenName, // todo: go to profile
        "@${userMention.screenName}",
        LinkType.mention,
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
  final LinkType type;

  const TwitterLinkModel(
    this.startIndex,
    this.endIndex,
    this.url,
    this.displayUrl,
    this.type,
  );

  @override
  String toString() {
    return 'TwitterLink{startIndex: $startIndex, endIndex: $endIndex, url: $url, displayUrl: $displayUrl}';
  }
}

enum LinkType {
  hashtag,
  mention,
  url,
}
