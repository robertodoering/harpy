import 'package:flutter/foundation.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/filesystem/directory_service.dart';

/// Wraps [compute] and does work in an isolate to prevent the ui thread from
/// doing too much work.
///
/// Calls the [callback] with [message] in an isolate. [callback] has to be a
/// top level function.
///
/// [tweetCacheData] can be used to initialize the [TweetCache].
Future<R> isolateWork<Q, R>({
  @required ComputeCallback<Q, R> callback,
  @required Q message,
  TweetCacheData tweetCacheData,
}) async {
  List args = [
    callback,
    message,
    DirectoryService().data,
    tweetCacheData,
  ];

  return await compute<List, dynamic>(_isolateInit, args);
}

/// Called by [isolateWork] to initialize the [DirectoryService] and
/// optionally the [TweetCache] before calling the [callback].
dynamic _isolateInit(List args) {
  Function callback = args[0];
  dynamic message = args[1];

  DirectoryService().data = args[2];
  if (args[3] is TweetCacheData) {
    TweetCache(args[3]);
  }

  return callback(message);
}
