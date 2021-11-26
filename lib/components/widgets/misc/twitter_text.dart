import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:share_plus/share_plus.dart';

/// Signature for callbacks that are called when an entity has been tapped.
typedef EntityTapped<T> = void Function(BuildContext context, T value);

/// The default behavior when a user mention inside of [TwitterText] is tapped.
void defaultOnUserMentionTap(
  BuildContext context,
  UserMentionData userMention,
) {
  app<HarpyNavigator>().pushUserProfile(
    currentRoute: ModalRoute.of(context)!.settings,
    handle: userMention.handle,
  );
}

/// The default behavior when a url inside of [TwitterText] is tapped.
void defaultOnUrlTap(BuildContext context, UrlData url) {
  launchUrl(url.expandedUrl);
}

/// The default behavior when a url inside of [TwitterText] is long pressed.
void defaultOnUrlLongPress(BuildContext context, UrlData url) {
  showHarpyBottomSheet<void>(
    context,
    hapticFeedback: true,
    children: [
      BottomSheetHeader(
        child: Text(url.expandedUrl),
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open url externally'),
        onTap: () {
          launchUrl(url.expandedUrl);
          app<HarpyNavigator>().maybePop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy url text'),
        onTap: () {
          Clipboard.setData(ClipboardData(text: url.expandedUrl));
          app<HarpyNavigator>().maybePop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share url'),
        onTap: () {
          Share.share(url.expandedUrl);
          app<HarpyNavigator>().maybePop();
        },
      ),
    ],
  );
}

/// The default behavior when a [Hashtag] inside of a [TwitterText] is tapped.
void defaultOnHashtagTap(BuildContext context, HashtagData hashtag) {
  if (hashtag.text.trim().isNotEmpty) {
    final searchQuery = '#${hashtag.text}';

    if (ModalRoute.of(context)!.settings.name == TweetSearchScreen.route) {
      // already in tweet search
      context.read<TweetSearchCubit>().search(customQuery: searchQuery);
    } else {
      app<HarpyNavigator>().pushTweetSearchScreen(
        initialSearchQuery: '#${hashtag.text}',
      );
    }
  }
}

/// Builds a [Text] widget with the [entities] parsed in the [text].
///
/// The entity texts are styled with [entityStyle] and the relevant callback
/// is fired when the entity is tapped.
class TwitterText extends StatefulWidget {
  const TwitterText(
    this.text, {
    this.entities,
    this.entityStyle,
    this.style,
    this.maxLines,
    this.overflow,
    this.urlToIgnore,
    this.onHashtagTap = defaultOnHashtagTap,
    this.onUrlTap = defaultOnUrlTap,
    this.onUrlLongPress = defaultOnUrlLongPress,
    this.onUserMentionTap = defaultOnUserMentionTap,
  });

  /// The full twitter text.
  final String text;

  /// The entities appearing in the [text].
  final EntitiesData? entities;

  /// The style of the entity in the text.
  ///
  /// Uses a bold font weight with the accent color if `null`.
  final TextStyle? entityStyle;

  /// The text style used as a base for the text.
  final TextStyle? style;

  /// An optional maximum number of lines for the text to span, wrapping if
  /// necessary.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// A url that won't be built if it is part of [Entities.urls].
  ///
  /// Used to hide the quoted status url that appears at the end of the text
  /// when the tweet includes a quote.
  final String? urlToIgnore;

  /// Called when a hashtag is tapped.
  final EntityTapped<HashtagData>? onHashtagTap;

  /// Called when a url is tapped.
  ///
  /// Set to [defaultOnUrlTap] by default.
  final EntityTapped<UrlData>? onUrlTap;

  /// Called when a url is long pressed.
  ///
  /// Set to [defaultOnUrlLongPress] by default.
  final EntityTapped<UrlData> onUrlLongPress;

  /// Called when a user mention is tapped.
  ///
  /// Set to [defaultOnUserMentionTap] by default.
  final EntityTapped<UserMentionData>? onUserMentionTap;

  @override
  _TwitterTextState createState() => _TwitterTextState();
}

class _TwitterTextState extends State<TwitterText> {
  final List<GestureRecognizer> _gestureRecognizer = [];

  final List<TwitterTextSpan> _textSpans = [];

  @override
  void initState() {
    super.initState();

    final twitterTextEntities = widget.entities != null
        ? _initializeEntities(widget.text, widget.entities!)
        : <TwitterTextEntity>[];

    var textStart = 0;

    for (final entity in twitterTextEntities) {
      final textEnd = entity.startIndex;

      _addTextSpan(textStart, textEnd);
      _addEntityTextSpan(entity);

      textStart = entity.endIndex;
    }

    _addTextSpan(textStart, widget.text.length, trimEnd: true);
  }

  /// Adds the plain text with html entities parsed into the proper symbol.
  ///
  /// [trimEnd] can be used to trim the last whitespace character in the text
  /// span. This is used to prevent soft wraps at the end of the [TwitterText]
  /// with only one wrapped whitespace character.
  void _addTextSpan(int start, int end, {bool trimEnd = false}) {
    if (start < end && end <= widget.text.length) {
      final text = parseHtmlEntities(
        trimOne(
          widget.text.substring(start, end),
          begin: false,
          end: trimEnd,
        ),
      )!;

      if (text.isNotEmpty) {
        _textSpans.add(
          TwitterTextSpan(text),
        );
      }
    }
  }

  /// Adds the styled entity text with a gesture recognizer.
  void _addEntityTextSpan(TwitterTextEntity entity) {
    final dynamic value = entity.value;

    if (value is Media) {
      // hide the media url at the end of the text
      return;
    }

    String? text;
    GestureRecognizer? recognizer;

    if (value is HashtagData) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onHashtagTap?.call(context, value);

      text = '#${value.text}';
    } else if (value is UrlData) {
      if (value.url == widget.urlToIgnore) {
        // hide the url to ignore
        // usually the quoted status link at the end of the text
        return;
      }

      recognizer = MultiTapGestureRecognizer(longTapDelay: kLongPressTimeout)
        ..onTap = ((_) => widget.onUrlTap?.call(context, value))
        ..onLongTapDown = (_, __) => widget.onUrlLongPress.call(
              context,
              value,
            );

      text = value.displayUrl;
    } else if (value is UserMentionData) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onUserMentionTap?.call(context, value);

      text = '@${value.handle}';
    }

    if (recognizer != null) {
      _gestureRecognizer.add(recognizer);
    }

    if (text != null) {
      _textSpans.add(
        TwitterTextSpan(
          text,
          recognizer: recognizer,
          entity: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final recognizer in _gestureRecognizer) {
      recognizer.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entityStyle = widget.entityStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.secondary,
        );

    return Text.rich(
      TextSpan(
        children: [
          for (TwitterTextSpan textSpan in _textSpans)
            TextSpan(
              text: textSpan.text,
              recognizer: textSpan.recognizer,
              style: textSpan.entity ? entityStyle : null,
            )
        ],
      ),
      style: widget.style,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}

/// Returns a list of [TwitterTextEntity] from the [entities] as they appear in
/// the [text] sorted by their occurrence.
///
/// The [Tweet] object returns the indices where the entity appears in the full
/// tweet text that should make it easy to parse, however we can't use that
/// since the utf8 encoded characters that are returned by Twitter are handled
/// differently in dart.
/// Therefore we use [_findIndices] to find the entity indices ourselves.
List<TwitterTextEntity> _initializeEntities(
  String text,
  EntitiesData entities,
) {
  final twitterTextEntities = <TwitterTextEntity>[];

  // hashtags
  var indexStart = 0;
  for (final hashtag in entities.hashtags) {
    // Look for the indices of our hashtag entity
    var indices = _findIndices(text, '#${hashtag.text}', indexStart);

    // if indices is still null, we search again with the other
    // legal hashtag start symbol, "＃" (see pr #343)
    indices ??= _findIndices(text, '＃${hashtag.text}', indexStart);

    indexStart = indices != null ? indices.last : indexStart;

    _addEntity(TwitterTextEntity(indices, hashtag), twitterTextEntities);
  }

  // urls
  indexStart = 0;
  for (final url in entities.urls) {
    final indices = _findIndices(text, url.url, indexStart);
    indexStart = indices != null ? indices.last : indexStart;

    _addEntity(TwitterTextEntity(indices, url), twitterTextEntities);
  }

  // user mentions
  indexStart = 0;
  for (final userMention in entities.userMentions) {
    final indices = _findIndices(text, '@${userMention.handle}', indexStart);
    indexStart = indices != null ? indices.last : indexStart;

    _addEntity(
      TwitterTextEntity(indices, userMention),
      twitterTextEntities,
    );
  }

  // media
  indexStart = 0;
  for (final media in entities.media) {
    final indices = _findIndices(text, media.url, indexStart);
    indexStart = indices != null ? indices.last : indexStart;

    _addEntity(TwitterTextEntity(indices, media), twitterTextEntities);
  }

  return twitterTextEntities;
}

/// Finds and returns the start and end index for the entity in the [text].
///
/// We can't rely on the Twitter returned indices as they are counted
/// differently in dart when unicode characters are involved, even when using
/// the https://pub.dev/packages/characters package for counting the characters.
///
/// Returns `null` if the [entityText] has not been found in the text.
List<int>? _findIndices(String text, String entityText, int indexStart) {
  try {
    final start = text.toLowerCase().indexOf(
          entityText.toLowerCase(),
          indexStart,
        );

    if (start != -1) {
      final end = start + entityText.length;
      return [start, end];
    }
  } catch (e) {
    // assume indices can't be found
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

  for (var i = 0; i < twitterTextEntities.length; i++) {
    if (entity.startIndex < twitterTextEntities[i].startIndex) {
      twitterTextEntities.insert(i, entity);
      return;
    }
  }

  twitterTextEntities.add(entity);
}

/// Represents an entity and its location in twitter text.
class TwitterTextEntity {
  const TwitterTextEntity(this.indices, this.value);

  /// The indices of the entity in the text.
  ///
  /// The length must always be exactly 2 to represent the start and end
  /// indices.
  final List<int>? indices;

  /// The entity value.
  ///
  /// Types include [HashtagData], [UrlData], [UserMentionData] and
  /// [EntitiesMediaData].
  final dynamic value;

  bool get valid => indices?.length == 2;

  int get startIndex => indices![0];

  int get endIndex => indices![1];
}

/// A class that represents a text span for the [TwitterText].
class TwitterTextSpan {
  const TwitterTextSpan(
    this.text, {
    this.recognizer,
    this.entity = false,
  });

  /// The text for this text span.
  final String text;

  /// An optional gesture recognizer for this text span.
  final GestureRecognizer? recognizer;

  /// Whether this text span represents an entity and should be styled
  /// differently.
  final bool entity;
}
