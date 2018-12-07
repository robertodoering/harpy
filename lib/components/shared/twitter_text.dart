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
  /// A list of [GestureRecognizer] for each entity.
  ///
  /// It's necessary to keep the reference so that we can dispose them.
  List<GestureRecognizer> _gestureRecognizer = [];

  List<TextSpan> _textSpans = [];

  @override
  void initState() {
    super.initState();

    // parse text
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

      _textSpans.add(TextSpan(
        text: text,
        style: HarpyTheme.theme.textTheme.body1,
      ));
    }
  }

  void _addEntityModel(TwitterEntityModel entityModel) {
    GestureRecognizer recognizer = null;

    if (widget.onEntityTap != null) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onEntityTap(entityModel);
      _gestureRecognizer.add(recognizer);
    }

    _textSpans.add(TextSpan(
      text: "${entityModel.displayUrl} ",
      style: HarpyTheme.theme.textTheme.body1.copyWith(
        color: widget.entityColor,
        fontWeight: FontWeight.bold,
      ),
      recognizer: recognizer,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _gestureRecognizer.forEach((recognizer) => recognizer.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _textSpans,
      ),
    );
  }
}

/// Takes a [String] and [Entities] and creates a list of [TwitterEntityModel]
/// with an entry for each entity.
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

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: hashtag.text,
        displayUrl: "#${hashtag.text}",
        type: EntityType.hashtag,
      );
      _addEntityModel(entityModel);
    }

    for (var url in entities.urls) {
      var indices = _findIndices(text, url.url);
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: url.expandedUrl,
        displayUrl: url.displayUrl,
        type: EntityType.url,
      );
      _addEntityModel(entityModel);
    }

    for (var userMention in entities.userMentions) {
      var indices = _findIndices(text, "@${userMention.screenName}");
      if (indices == null) break;

      var entityModel = TwitterEntityModel(
        startIndex: indices[0],
        endIndex: indices[1],
        url: userMention.screenName,
        displayUrl: "@${userMention.screenName}",
        type: EntityType.mention,
      );
      _addEntityModel(entityModel);
    }
  }

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
