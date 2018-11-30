import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/theme.dart';

/// Creates a [RichText] from the given [text].
///
/// The [Entities] will be parsed and appear in the [entityColor].
class TwitterText extends StatefulWidget {
  final String text;
  final Entities entities;
  final Color entityColor;
  final ValueChanged<TwitterEntityModel> onEntityTap;

  const TwitterText({
    @required this.text,
    this.entities,
    this.entityColor = HarpyTheme.primaryColor,
    this.onEntityTap,
  });

  @override
  TwitterTextState createState() => TwitterTextState();
}

class TwitterTextState extends State<TwitterText> {
  List<GestureRecognizer> gestureRecognizer = [];

  @override
  void dispose() {
    super.dispose();
    gestureRecognizer.forEach((recognizer) => recognizer.dispose());
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    var twitterEntities = TwitterEntities(
      widget.text,
      widget.entities,
    );

    TwitterEntityModel nextEntity;
    int textStart = 0;

    print("----------");
    print(widget.text);
    print(widget.entities);

//    for (var entityModel in twitterEntities.entityModels) {
//
//      // twitter entity
//      GestureRecognizer recognizer = null;
//      if (nextEntity.type == EntityType.url) {
//        recognizer = TapGestureRecognizer()
//          ..onTap = () => widget.onEntityTap(nextEntity);
//        gestureRecognizer.add(recognizer);
//      }
//
//      textSpans.add(TextSpan(
//        text: "${nextEntity.displayUrl} ",
//        style: Theme.of(context).textTheme.body1.copyWith(
//          color: widget.entityColor,
//          fontWeight: FontWeight.bold,
//        ),
//        recognizer: recognizer,
//      ));
//
//      textStart = nextEntity.endIndex + 1;
//
//    }

    do {
      nextEntity = twitterEntities.getNext();
      int textEnd;

      if (nextEntity != null) {
        textEnd = nextEntity.startIndex;
      } else {
        textEnd = widget.text.length;
      }

      // text
      if (textStart < textEnd) {
        String text = widget.text.substring(textStart, textEnd);

        print("-----");
        print(text);

        print("----------");

        textSpans.add(TextSpan(
          text: text,
          style: Theme.of(context).textTheme.body1,
        ));
      }

      // twitter entity
      if (nextEntity != null) {
        GestureRecognizer recognizer = null;
        if (nextEntity.type == EntityType.url) {
          recognizer = TapGestureRecognizer()
            ..onTap = () => widget.onEntityTap(nextEntity);
          gestureRecognizer.add(recognizer);
        }

        textSpans.add(TextSpan(
          text: "${nextEntity.displayUrl} ",
          style: Theme.of(context).textTheme.body1.copyWith(
                color: widget.entityColor,
                fontWeight: FontWeight.bold,
              ),
          recognizer: recognizer,
        ));

        textStart = nextEntity.endIndex + 1;
      }
    } while (nextEntity != null);

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

/// Takes a [String] and [Entities] and creates a list of [TwitterEntityModel]
/// an entry for each entity.
class TwitterEntities {
  /// A list of [TwitterEntityModel].
  var entityModels = <TwitterEntityModel>[];

  /// A map that contains the end index of each entity to find the next
  /// occurrence of a duplicate entity.
  var _entityMap = <String, int>{};

  TwitterEntities(String text, Entities entities) {
    for (var hashtag in entities.hashtags) {
      var indices = _findIndices(text, "#${hashtag.text}");
      if (indices == null) break;

      var link = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: hashtag.text, // todo: make request for hashtag
        displayUrl: "#${hashtag.text}",
        type: EntityType.hashtag,
      );
      _addLink(link);
    }

    for (var url in entities.urls) {
      var indices = _findIndices(text, url.url);
      if (indices == null) break;

      var link = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: url.expandedUrl, // todo: open link in browser
        displayUrl: url.displayUrl,
        type: EntityType.url,
      );
      _addLink(link);
    }

    for (var userMention in entities.userMentions) {
      var indices = _findIndices(text, "@${userMention.screenName}");
      if (indices == null) break;

      var link = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: userMention.screenName, // todo: go to profile
        displayUrl: "@${userMention.screenName}",
        type: EntityType.mention,
      );
      _addLink(link);
    }
  }

  /// Finds and returns the start and end index for the [entity] in the [text].
  ///
  /// Returns `null` if the entity has not been found in the text.
  List<int> _findIndices(String text, String entity) {
    print("find indice of $entity in $text");

    int start = text.indexOf(entity, _entityMap[entity] ?? 0);

    if (start != -1) {
      int end = start + entity.length;
      _entityMap[entity] = end + 1;

      print("found ${[start, end]}");

      return [start, end];
    }

    return null;
  }

  /// Adds a [link] to the [entityModels] list at the position where the
  /// indices are sorted ascending.
  void _addLink(TwitterEntityModel link) {
    for (int i = 0; i < entityModels.length; i++) {
      if (link.startIndex < entityModels[i].startIndex) {
        entityModels.insert(i, link);
        return;
      }
    }

    entityModels.add(link);
  }

  /// Returns the next [TwitterEntityModel] or null if there aren't any more.
  TwitterEntityModel getNext() {
    return entityModels.isNotEmpty ? entityModels.removeAt(0) : null;
  }
}

/// A simple model for the [Entities].
///
/// The [EntityType] can be used to differentiate between each entity.
class TwitterEntityModel {
  final int startIndex;
  final int endIndex;
  final String url;
  final String displayUrl;
  final EntityType type;

  const TwitterEntityModel({
    this.startIndex,
    this.endIndex,
    this.url,
    this.displayUrl,
    this.type,
  });
}

enum EntityType {
  hashtag,
  mention,
  url,
}
