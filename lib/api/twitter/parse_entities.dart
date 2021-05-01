import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/core.dart';

/// Parses hashtags and user mentions from the [text] into the [entities].
void parseEntities(String text, Entities entities) {
  entities.hashtags ??= <Hashtag>[];
  entities.userMentions ??= <UserMention>[];

  // Search for hashtags in text, ensure we correctly remove the
  //  start (valid characters are # and ＃)
  for (Match m in hashtagRegex.allMatches(text)) {
    final String hashtag = m.group(0);

    entities.hashtags
        .add(Hashtag()..text = hashtag.replaceFirst(RegExp(r'#|＃'), ''));
  }

  // Search for mentions in text
  for (Match m in mentionRegex.allMatches(text)) {
    final String mention = m.group(0);

    entities.userMentions
        .add(UserMention()..screenName = mention.replaceFirst('@', ''));
  }
}
