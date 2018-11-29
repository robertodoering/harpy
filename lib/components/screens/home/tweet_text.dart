import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/utils/url_launcher.dart';

class TweetText extends StatefulWidget {
  final Tweet tweet;

  const TweetText(this.tweet);

  @override
  TweetTextState createState() => TweetTextState();
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

    var twitterLinks = TweetLinks(widget.tweet.entities);

    TwitterLinkModel nextLink;
    int textStart = 0;

    print("----------");
    print(widget.tweet.full_text);
    print(widget.tweet.entities);

    if (widget.tweet.id == 1066732186068545537) {
      for (int i = 0; i < widget.tweet.full_text.codeUnits.length; i++) {
        int codeUnit = widget.tweet.full_text.codeUnits[i];

        print("codeUnit $i: $codeUnit");
        print(
            "String.fromCharCode(codeUnit): ${String.fromCharCode(codeUnit)}");
      }
    }

    do {
      nextLink = twitterLinks.getNext();
      int textEnd;

      if (nextLink != null) {
        textEnd = nextLink.startIndex + 1;
      } else {
        textEnd = widget.tweet.full_text.length;
      }

      // text
      if (textStart < textEnd) {
        String text = widget.tweet.full_text.substring(textStart, textEnd);

        print("-----");
        print("${widget.tweet.id}");
        print(text);

        print("----------");

        // text = utf.decodeUtf8(text.codeUnits);

        textSpans.add(TextSpan(
          text: text,
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

  TweetLinks(Entities entities) {
    for (var hashtag in entities.hashtags) {
      var link = TwitterLinkModel(
        hashtag.indices[0],
        hashtag.indices[1],
        hashtag.text, // todo: make request for hashtag
        "#${hashtag.text}",
        LinkType.hashtag,
      );
      _addLink(link);
    }

    for (var url in entities.urls) {
      var link = TwitterLinkModel(
        url.indices[0],
        url.indices[1],
        url.expandedUrl, // todo: open link in browser
        url.displayUrl,
        LinkType.url,
      );
      _addLink(link);
    }

    for (var userMention in entities.userMentions) {
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
