import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/hashtag.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user_mention.dart';
import 'package:harpy/core/utils/string_utils.dart';

/// Creates a [RichText] from the given [text].
///
/// The [Entities] will be parsed and appear in the [entityColor].
///
/// todo: refactor (with scoped model)
class TwitterText extends StatefulWidget {
  const TwitterText({
    @required this.text,
    this.entities,
    this.entityColor,
    this.onEntityTap,
  });

  final String text;
  final Entities entities;
  final Color entityColor;
  final ValueChanged<TwitterEntityModel> onEntityTap;

  @override
  TwitterTextState createState() => TwitterTextState();
}

class TwitterTextState extends State<TwitterText> {
  /// A list of [GestureRecognizer] for each entity.
  ///
  /// It's necessary to keep the reference so that we can dispose them.
  List<GestureRecognizer> _gestureRecognizer = [];

  /// The list of [_TwitterTextType] contains the parsed texts and its type.
  List<_TwitterTextType> _texts = [];

  @override
  void initState() {
    super.initState();

    _parseText();
  }

  void _parseText() {
    var twitterEntities = TwitterEntities(
      widget.text,
      widget.entities,
    );

    int textStart = 0;

    // add the text spans
    for (var entityModel in twitterEntities.entityModels) {
      int textEnd = entityModel.startIndex;

      _addText(textStart, textEnd);
      _addEntityModel(entityModel);

      textStart = entityModel.endIndex + 1;
    }

    int textEnd = widget.text.length;

    _addText(textStart, textEnd);
  }

  void _addText(int start, int end) {
    if (start < end && end <= widget.text.length) {
      String text = widget.text.substring(start, end);
      text = parseHtmlEntities(text);

      _texts.add(_TwitterTextType(text, _TextType.text));
    }
  }

  void _addEntityModel(TwitterEntityModel entityModel) {
    if (entityModel.type == EntityType.media) return;

    GestureRecognizer recognizer;

    if (widget.onEntityTap != null) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onEntityTap(entityModel);
      _gestureRecognizer.add(recognizer);
    }

    _texts.add(_TwitterTextType(
      "${entityModel.displayText} ",
      _TextType.entity,
      recognizer,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _gestureRecognizer.forEach((recognizer) => recognizer.dispose());
  }

  @override
  Widget build(BuildContext context) {
    // the styles used by the text and entities (urls, hashtags) of the tweet
    Map<_TextType, TextStyle> _styles = {
      _TextType.text: Theme.of(context).textTheme.body1,
      _TextType.entity: Theme.of(context).textTheme.body1.copyWith(
            color: widget.entityColor ?? Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
    };

    return Text.rich(
      TextSpan(
        children: _texts.map((textType) {
          return TextSpan(
            text: textType.text,
            style: _styles[textType.type],
            recognizer: textType.recognizer,
          );
        }).toList(),
      ),
    );
  }
}

/// A helper class that contains the type of a text to determine the text style.
class _TwitterTextType {
  final String text;
  final _TextType type;
  final GestureRecognizer recognizer;

  const _TwitterTextType(this.text, this.type, [this.recognizer]);
}

/// Takes a [String] and [Entities] and creates a list of [TwitterEntityModel]
/// with an entry for each entity.
class TwitterEntities {
  TwitterEntities(String text, Entities entities) {
    for (Hashtag hashtag in entities.hashtags ?? []) {
      var indices = _findIndices(text, "#${hashtag.text}");
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        data: hashtag.text,
        displayText: "#${hashtag.text}",
        type: EntityType.hashtag,
      );
      _addEntityModel(entityModel);
    }

    for (Url url in entities.urls ?? []) {
      var indices = _findIndices(text, url.url);
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        data: url.expandedUrl,
        displayText: url.displayUrl,
        type: EntityType.url,
      );
      _addEntityModel(entityModel);
    }

    for (UserMention userMention in entities.userMentions ?? []) {
      var indices = _findIndices(text, "@${userMention.screenName}");
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        data: userMention.screenName,
        id: "${userMention.id}",
        displayText: "@${userMention.screenName}",
        type: EntityType.mention,
      );
      _addEntityModel(entityModel);
    }

    for (TwitterMedia media in entities.media ?? []) {
      var indices = _findIndices(text, media.url);
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
          startIndex: indices[0],
          endIndex: indices[1],
          data: media.expandedUrl,
          displayText: media.displayUrl,
          type: EntityType.media);
      _addEntityModel(entityModel);
    }
  }

  /// A list of [TwitterEntityModel].
  final entityModels = <TwitterEntityModel>[];

  /// A map that contains the end index of each entity to find the next
  /// occurrence of a duplicate entity.
  final _entityMap = <String, int>{};

  /// Finds and returns the start and end index for the [entity] in the [text].
  ///
  /// Returns `null` if the entity has not been found in the text.
  List<int> _findIndices(String text, String entity) {
    int start = text.indexOf(entity, _entityMap[entity] ?? 0);

    if (start != -1) {
      int end = start + entity.length;
      _entityMap[entity] = end + 1;

      return [start, end];
    }

    return null;
  }

  /// Adds an [TwitterEntityModel] to the [entityModels] list at the position
  /// where the indices are sorted ascending.
  void _addEntityModel(TwitterEntityModel entityModel) {
    for (int i = 0; i < entityModels.length; i++) {
      if (entityModel.startIndex < entityModels[i].startIndex) {
        entityModels.insert(i, entityModel);
        return;
      }
    }

    entityModels.add(entityModel);
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
  const TwitterEntityModel({
    this.startIndex,
    this.endIndex,
    this.data,
    this.id,
    this.displayText,
    this.type,
  });

  final int startIndex;
  final int endIndex;

  /// The [data] for the entity.
  ///
  /// The url for [EntityType.url] and [EntityType.media].
  /// The [User.screenName] for [EntityType.mention].
  final String data;

  /// The [User.id] for [EntityType.mention].
  final String id;

  /// The text that should be displayed in the [TwitterText].
  final String displayText;

  final EntityType type;
}

enum EntityType {
  hashtag,
  mention,
  url,
  media,
}

enum _TextType {
  text,
  entity,
}
