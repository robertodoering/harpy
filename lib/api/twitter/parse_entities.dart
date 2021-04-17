import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/core.dart';

/// Parses hashtags and user mentions from the [text] into the [entities].
void parseEntities(String text, Entities entities) {
  entities.hashtags ??= <Hashtag>[];
  entities.userMentions ??= <UserMention>[];

  for (String part in text.split(whitespaceRegex)) {
    // todo: fix remove trailing special characters in entities
    //   (@username. => remove the .)
    if (part.startsWith('#')) {
      entities.hashtags.add(
        Hashtag()..text = part.replaceFirst('#', ''),
      );
    } else if (part.startsWith('@')) {
      entities.userMentions.add(
        UserMention()..screenName = part.replaceFirst('@', ''),
      );
    }
  }
}
