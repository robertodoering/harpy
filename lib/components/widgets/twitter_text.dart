import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

/// Signature for callbacks that are called when an entity has been tapped.
typedef EntityTapped<T> = void Function(WidgetRef ref, T value);

void defaultOnUserMentionTap(WidgetRef ref, UserMentionData mention) {
  final router = ref.read(routerProvider);

  if (!router.location.endsWith(mention.handle)) {
    router.pushNamed(
      UserPage.name,
      params: {'handle': mention.handle},
    );
  }
}

void defaultOnUrlTap(WidgetRef ref, UrlData url) {
  HapticFeedback.lightImpact();
  ref.read(launcherProvider)(url.expandedUrl);
}

void defaultOnUrlLongPress(WidgetRef ref, UrlData url) {
  showRbyBottomSheet<void>(
    ref.context,
    children: [
      BottomSheetHeader(child: Text(url.expandedUrl)),
      RbyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open url externally'),
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(launcherProvider)(
            url.expandedUrl,
            alwaysOpenExternally: true,
          );
          Navigator.of(ref.context).pop();
        },
      ),
      RbyListTile(
        leading: const Icon(CupertinoIcons.square_on_square),
        title: const Text('copy url'),
        onTap: () {
          HapticFeedback.lightImpact();
          Clipboard.setData(ClipboardData(text: url.expandedUrl));
          Navigator.of(ref.context).pop();
        },
      ),
      RbyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share url'),
        onTap: () {
          HapticFeedback.lightImpact();
          Share.share(url.expandedUrl);
          Navigator.of(ref.context).pop();
        },
      ),
    ],
  );
}

void defaultOnHashtagTap(WidgetRef ref, TagData hashtag) {
  final searchQuery = '#${hashtag.text}';

  if (ref.read(tweetSearchProvider) != const TweetSearchState.initial()) {
    // active tweet search already exists
    ref.read(tweetSearchProvider.notifier).search(customQuery: searchQuery);
  } else {
    ref.read(routerProvider).pushNamed(
      TweetSearchPage.name,
      queryParams: {'query': searchQuery},
    );
  }
}

/// Builds a [Text] widget with the [entities] parsed in the [text].
///
/// The entity texts are styled with [entityStyle] and the relevant callback
/// is fired when the entity is tapped.
class TwitterText extends ConsumerStatefulWidget {
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

  final String text;
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

  /// A url that will be removed if it is part of [Entities.urls].
  ///
  /// Used to hide the quoted status url that appears at the end of the text
  /// when the tweet includes a quote.
  final String? urlToIgnore;

  final EntityTapped<TagData>? onHashtagTap;
  final EntityTapped<UrlData>? onUrlTap;
  final EntityTapped<UrlData> onUrlLongPress;
  final EntityTapped<UserMentionData>? onUserMentionTap;

  @override
  ConsumerState<TwitterText> createState() => _TwitterTextState();
}

class _TwitterTextState extends ConsumerState<TwitterText> {
  final List<GestureRecognizer> _gestureRecognizer = [];
  final List<_TwitterTextSpan> _textSpans = [];

  @override
  void initState() {
    super.initState();

    final twitterTextEntities = widget.entities != null
        ? _initializeEntities(widget.text, widget.entities!)
        : <_TwitterTextEntity>[];

    var textStart = 0;

    for (final entity in twitterTextEntities) {
      final textEnd = entity.indices.item1;

      _addTextSpan(textStart, textEnd);
      _addEntityTextSpan(entity);

      textStart = entity.indices.item2;
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
      );

      if (text.isNotEmpty) _textSpans.add(_TwitterTextSpan(text));
    }
  }

  /// Adds the styled entity text with a gesture recognizer.
  void _addEntityTextSpan(_TwitterTextEntity entity) {
    final dynamic value = entity.value;

    if (value is Media) {
      // hide the media url at the end of the text
      return;
    }

    String? text;
    GestureRecognizer? recognizer;

    if (value is TagData) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onHashtagTap?.call(ref, value);

      text = '#${value.text}';
    } else if (value is UrlData) {
      if (value.url == widget.urlToIgnore) {
        // hide the url to ignore
        // usually the quoted status link at the end of the text
        return;
      }

      recognizer = MultiTapGestureRecognizer(longTapDelay: kLongPressTimeout)
        ..onTap = ((_) => widget.onUrlTap?.call(ref, value))
        ..onLongTapDown = (_, __) => widget.onUrlLongPress.call(ref, value);

      text = value.displayUrl;
    } else if (value is UserMentionData) {
      recognizer = TapGestureRecognizer()
        ..onTap = () => widget.onUserMentionTap?.call(ref, value);

      text = '@${value.handle}';
    }

    if (recognizer != null) _gestureRecognizer.add(recognizer);

    if (text != null) {
      _textSpans.add(
        _TwitterTextSpan(
          text,
          recognizer: recognizer,
          isEntity: true,
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

    // we prevent semantics for the text because the MultiTapGestureRecognizer
    // is not supported and throws assertions
    return ExcludeSemantics(
      child: Text.rich(
        TextSpan(
          children: [
            for (final textSpan in _textSpans)
              TextSpan(
                text: textSpan.text,
                recognizer: textSpan.recognizer,
                style: textSpan.isEntity ? entityStyle : null,
              ),
          ],
        ),
        style: widget.style,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}

/// Returns a list of [_TwitterTextEntity] from the [entities] as they appear in
/// the [text] sorted by their occurrence.
///
/// The [Tweet] object returns the indices where the entity appears in the full
/// tweet text that should make it easy to parse, however we can't use that
/// since the utf8 encoded characters that are returned by Twitter are handled
/// differently in dart.
/// Therefore we use [_findIndices] to find the entity indices ourselves.
List<_TwitterTextEntity> _initializeEntities(
  String text,
  EntitiesData entities,
) {
  final twitterTextEntities = <_TwitterTextEntity>[];

  // hashtags
  var indexStart = 0;
  for (final hashtag in entities.hashtags) {
    final indices = _findIndices(text, '#${hashtag.text}', indexStart) ??
        _findIndices(text, '＃${hashtag.text}', indexStart);

    if (indices != null) {
      indexStart = indices.item2;
      _addEntity(_TwitterTextEntity(indices, hashtag), twitterTextEntities);
    }
  }

  // urls
  indexStart = 0;
  for (final url in entities.urls) {
    final indices = _findIndices(text, url.url, indexStart);

    if (indices != null) {
      indexStart = indices.item2;
      _addEntity(_TwitterTextEntity(indices, url), twitterTextEntities);
    }
  }

  // user mentions
  indexStart = 0;
  for (final userMention in entities.userMentions) {
    final indices = _findIndices(text, '@${userMention.handle}', indexStart);

    if (indices != null) {
      indexStart = indices.item2;
      _addEntity(_TwitterTextEntity(indices, userMention), twitterTextEntities);
    }
  }

  // media
  indexStart = 0;
  for (final media in entities.media) {
    final indices = _findIndices(text, media.url, indexStart);

    if (indices != null) {
      indexStart = indices.item2;
      _addEntity(_TwitterTextEntity(indices, media), twitterTextEntities);
    }
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
Tuple2<int, int>? _findIndices(String text, String entityText, int indexStart) {
  try {
    final start = text.toLowerCase().indexOf(
          entityText.toLowerCase(),
          indexStart,
        );

    if (start != -1) return Tuple2(start, start + entityText.length);
  } catch (e) {
    // assume indices can't be found
  }

  return null;
}

void _addEntity(
  _TwitterTextEntity entity,
  List<_TwitterTextEntity> twitterTextEntities,
) {
  for (var i = 0; i < twitterTextEntities.length; i++) {
    if (entity.indices.item1 < twitterTextEntities[i].indices.item1) {
      twitterTextEntities.insert(i, entity);
      return;
    }
  }

  twitterTextEntities.add(entity);
}

class _TwitterTextEntity {
  const _TwitterTextEntity(this.indices, this.value);

  final Tuple2<int, int> indices;

  /// The entity value.
  ///
  /// Types include [TagData], [UrlData], [UserMentionData] and
  /// [EntitiesMediaData].
  final dynamic value;
}

class _TwitterTextSpan {
  const _TwitterTextSpan(
    this.text, {
    this.recognizer,
    this.isEntity = false,
  });

  final String text;
  final GestureRecognizer? recognizer;
  final bool isEntity;
}
