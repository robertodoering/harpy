import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/misc/utils/string_utils.dart';

/// Signature for callbacks that report that an entity has been tapped.
typedef EntityTapped<T> = void Function(T value);

/// Builds a [Text] widget with the [entities] parsed in the [text].
///
/// The entity texts are styled with [entityColor] and the appropriate callback
/// is fired when the entity is tapped.
class TwitterText extends StatefulWidget {
  const TwitterText(
    this.text, {
    this.entities,
    this.entityColor,
    this.onHashtagTap,
    this.onUrlTap,
    this.onUserMentionTap,
  });

  /// The full twitter text.
  final String text;

  /// The entities appearing in the [text].
  final Entities entities;

  /// The color of the entity in the text.
  final Color entityColor;

  /// Called when a hashtag is tapped.
  final EntityTapped<Hashtag> onHashtagTap;

  /// Called when an url is tapped.
  final EntityTapped<Url> onUrlTap;

  /// Called when a user mention is tapped.
  final EntityTapped<UserMention> onUserMentionTap;

  @override
  _TwitterTextState createState() => _TwitterTextState();
}

class _TwitterTextState extends State<TwitterText> {
  final List<GestureRecognizer> _gestureRecognizer = <GestureRecognizer>[];

  final List<TextSpan> _textSpans = <TextSpan>[];

  @override
  void initState() {
    super.initState();

    final List<TwitterTextEntity> twitterTextEntities = _initializeEntities(
      widget.text,
      widget.entities,
    );

    int textStart = 0;

    for (TwitterTextEntity entity in twitterTextEntities) {
      final int textEnd = entity.startIndex;

      _addTextSpan(textStart, textEnd);
      _addEntityTextSpan(entity);

      textStart = entity.endIndex;
    }

    _addTextSpan(textStart, widget.text.length);
  }

  /// Adds the plain text with html entities parsed into the proper symbol.
  void _addTextSpan(int start, int end) {
    if (start < end && end <= widget.text.length) {
      _textSpans.add(
        TextSpan(text: parseHtmlEntities(widget.text.substring(start, end))),
      );
    }
  }

  /// Adds the styled entity text with a gesture recognizer.
  void _addEntityTextSpan(TwitterTextEntity entity) {
    final dynamic value = entity.value;

    if (value is Media) {
      // hide the media url at the end of the text
      return;
    }

    String text;
    TapGestureRecognizer recognizer;

    if (value is Hashtag) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onHashtagTap?.call(value);
      _gestureRecognizer.add(recognizer);

      text = '#${value.text}';
    }

    if (value is Url) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onUrlTap?.call(value);
      _gestureRecognizer.add(recognizer);

      text = value.displayUrl;
    }

    if (value is UserMention) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onUserMentionTap?.call(value);
      _gestureRecognizer.add(recognizer);

      text = '@${value.screenName}';
    }

    if (text != null) {
      _textSpans.add(
        TextSpan(
          text: text,
          recognizer: recognizer,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.entityColor,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (GestureRecognizer recognizer in _gestureRecognizer) {
      recognizer.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _textSpans),
    );
  }
}

/// Returns a list of [TwitterTextEntity] from the [entities] as they appear in
/// the [text] sorted by their occurrence.
List<TwitterTextEntity> _initializeEntities(String text, Entities entities) {
  final List<TwitterTextEntity> twitterTextEntities = <TwitterTextEntity>[];

  int indexStart = 0;
  for (Hashtag hashtag in entities?.hashtags ?? <Hashtag>[]) {
    final List<int> indices = _findIndices(
      text,
      '#${hashtag.text}',
      indexStart,
    );
    indexStart = indices != null ? indices.last + 1 : indexStart;

    _addEntity(TwitterTextEntity(indices, hashtag), twitterTextEntities);
  }

  indexStart = 0;
  for (Url url in entities?.urls ?? <Url>[]) {
    final List<int> indices = _findIndices(text, url.url, indexStart);
    indexStart = indices != null ? indices.last + 1 : indexStart;

    _addEntity(TwitterTextEntity(indices, url), twitterTextEntities);
  }

  indexStart = 0;
  for (UserMention userMention in entities?.userMentions ?? <UserMention>[]) {
    final List<int> indices = _findIndices(
      text,
      '@${userMention.screenName}',
      indexStart,
    );
    indexStart = indices != null ? indices.last + 1 : indexStart;

    _addEntity(
      TwitterTextEntity(indices, userMention),
      twitterTextEntities,
    );
  }

  indexStart = 0;
  for (Media media in entities?.media ?? <Media>[]) {
    final List<int> indices = _findIndices(text, media.url, indexStart);
    indexStart = indices != null ? indices.last + 1 : indexStart;

    _addEntity(TwitterTextEntity(indices, media), twitterTextEntities);
  }

  return twitterTextEntities;
}

/// Finds and returns the start and end index for the [entity] in the [text].
///
/// We can't rely on the twitter returned indices as they are counted
/// differently in dart when unicode characters are involved, even when using
/// the https://pub.dev/packages/characters package for counting the characters.
///
/// Returns `null` if the [entityText] has not been found in the text.
List<int> _findIndices(String text, String entityText, int indexStart) {
  final int start = text.indexOf(entityText, indexStart);

  if (start != -1) {
    final int end = start + entityText.length;
    return <int>[start, end];
  }

  return null;
}

/// Adds the [entity] to the list if it is valid, sorted by the index.
void _addEntity(
  TwitterTextEntity entity,
  List<TwitterTextEntity> twitterTextEntities,
) {
  if (!entity.valid) {
    return;
  }

  for (int i = 0; i < twitterTextEntities.length; i++) {
    if (entity.startIndex < twitterTextEntities[i].startIndex) {
      twitterTextEntities.insert(i, entity);
      return;
    }
  }

  twitterTextEntities.add(entity);
}

/// Represents an entity and its location in twitter text.
@immutable
class TwitterTextEntity {
  const TwitterTextEntity(this.indices, this.value);

  /// The indices of the entity in the text.
  ///
  /// The length must always be exactly 2 to represent the start and end
  /// indices.
  final List<int> indices;

  /// The entity value.
  ///
  /// Types include [Hashtag], [Url], [UserMention] and [Media].
  final dynamic value;

  bool get valid => indices?.length == 2;

  int get startIndex => indices[0];

  int get endIndex => indices[1];
}
