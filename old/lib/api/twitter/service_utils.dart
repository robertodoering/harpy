import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("ServiceUtils");

/// Sorts the [tweets] to group a reply chain of tweets together.
///
/// The parent of the reply/replies will be pushed up to where the last reply
/// is.
List<Tweet> sortTweetReplies(List<Tweet> tweets) {
  _log.fine("sorting tweet replies");

  final sorted = <Tweet>[];

  for (final tweet in tweets) {
    // skip the tweet if it has been added already in a reply chain
    if (sorted.contains(tweet)) continue;

    // if the tweet is a reply, add the reply chain for that tweet
    if (tweet.inReplyToStatusIdStr != null) {
      sorted.addAll(
        _addTweetReply(
          tweet,
          tweets.sublist(tweets.indexOf(tweet)),
        ),
      );
    } else {
      sorted.add(tweet);
    }
  }

  _log.fine("sorted ${tweets.length} tweets");

  return sorted;
}

/// Returns the tweet reply chain as a list for the [tweet] that is a reply to
/// another tweet in [tweets] list.
List<Tweet> _addTweetReply(Tweet tweet, List<Tweet> tweets) {
  final thread = <Tweet>[];

  final parent = tweets.firstWhere(
    (compare) => compare.idStr == tweet.inReplyToStatusIdStr,
    orElse: () => null,
  );

  if (parent != null) {
    final threadParent = _getReplyThreadParent(parent, tweets);
    thread
      ..add(threadParent)
      ..addAll(_getReplyThreadChildren(threadParent, tweets));
  } else {
    // this tweet is not a reply to a tweet in the list, just add it normally
    thread.add(tweet);
  }

  return thread;
}

/// Gets the parent of a reply chain.
Tweet _getReplyThreadParent(Tweet tweet, List<Tweet> tweets) {
  final Tweet parent = tweets.firstWhere(
    (compare) => compare.idStr == tweet.inReplyToStatusIdStr,
    orElse: () => null,
  );

  if (parent == null) {
    tweet.harpyData.parentOfReply = true;
    return tweet;
  } else {
    return _getReplyThreadParent(parent, tweets);
  }
}

/// Gets all replies with their replies to a parent tweet.
List<Tweet> _getReplyThreadChildren(Tweet tweet, List<Tweet> tweets) {
  final List<Tweet> threadChildren = [];

  final List<Tweet> children = _getTweetReplies(tweet, tweets);

  for (Tweet child in children) {
    child.harpyData.childOfReply = true;
    threadChildren
      ..add(child)
      ..addAll(_getReplyThreadChildren(child, tweets));
  }

  return threadChildren;
}

/// Gets all replies of one tweet.
List<Tweet> _getTweetReplies(Tweet tweet, List<Tweet> tweets) {
  return tweets.reversed
      .where((compare) => compare.inReplyToStatusIdStr == tweet.idStr)
      .toList();
}
