import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

/// Parses hashtags and user mentions from the [text].
EntitiesData parseEntities(String text) {
  final hashtags = <HashtagData>[];
  final userMentions = <UserMentionData>[];

  // Search for hashtags in text, ensure we correctly remove the
  //  start (valid characters are # and ＃)
  for (final match in hashtagRegex.allMatches(text)) {
    final hashtag = match.group(0);

    if (hashtag != null) {
      hashtags.add(
        HashtagData(
          text: hashtag.replaceFirst(RegExp('#|＃'), ''),
        ),
      );
    }
  }

  // Search for mentions in text
  for (final match in mentionRegex.allMatches(text)) {
    final mention = match.group(0);

    if (mention != null) {
      userMentions.add(
        UserMentionData(
          handle: mention.replaceFirst('@', ''),
        ),
      );
    }
  }

  return EntitiesData(
    hashtags: hashtags,
    userMentions: userMentions,
  );
}
