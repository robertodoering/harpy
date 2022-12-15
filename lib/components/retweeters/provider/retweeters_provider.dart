import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';

final retweetersProvider =
    FutureProvider.autoDispose.family<BuiltList<UserData>, String>(
  (ref, tweetId) async {
    return ref
        .watch(twitterApiV1Provider)
        .tweetService
        .retweets(id: tweetId, count: 100)
        .then(
          (tweets) => tweets.map(
            (tweet) => tweet.user != null ? UserData.fromV1(tweet.user!) : null,
          ),
        )
        .then((value) => value.whereType<UserData>().toBuiltList());
  },
  name: 'RetweetersProvider',
);
