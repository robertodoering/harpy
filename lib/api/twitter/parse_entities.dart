import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/core.dart';

/// Parses hashtags and user mentions from the [text] into the [entities].
void parseEntities(String text, Entities entities) {
  entities.hashtags ??= <Hashtag>[];
  entities.userMentions ??= <UserMention>[];

  // Match against all entities in the text
  final Iterable<Match> entitiesFromText = entityRegex.allMatches(text);

  // For each match, we extract the entity and populate
  // entities.hashtags or entities.userMentions accordingly
  for (Match m in entitiesFromText) {
    final String part = m.group(0);
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
