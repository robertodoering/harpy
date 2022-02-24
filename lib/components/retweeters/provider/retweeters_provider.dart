import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';

final retweetersProvider =
    FutureProvider.autoDispose.family<BuiltList<UserData>, String>(
  (ref, tweetId) async {
    return ref
        .watch(twitterApiProvider)
        .tweetService
        .retweets(id: tweetId, count: 100)
        .then((tweets) => tweets.map((tweet) => UserData.fromUser(tweet.user)))
        .then((value) => value.toBuiltList());
  },
  name: 'RetweetersProvider',
);
