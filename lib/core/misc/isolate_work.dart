import 'package:flutter/foundation.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:harpy/core/misc/logger.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("IsolateWork");

/// Wraps [compute] and does work in an isolate to prevent the ui thread from
/// doing too much work.
///
/// Calls the [callback] with [message] in an isolate. [callback] has to be a
/// top level function.
///
/// [tweetCacheData] is used to initialize the [TweetCache] and
/// [directoryServiceData] is used to initialize the [DirectoryService].
///
/// If [tweetCacheData] is not `null` [directoryServiceData] mustn't be `null`.
Future<R> isolateWork<Q, R>({
  @required ComputeCallback<Q, R> callback,
  @required Q message,
  TweetCacheData tweetCacheData,
  DirectoryServiceData directoryServiceData,
}) async {
  assert(tweetCacheData == null ||
      (tweetCacheData != null && directoryServiceData != null));

  final args = [
    callback,
    message,
    directoryServiceData,
    tweetCacheData,
  ];

  return compute<List, dynamic>(_isolateInit, args);
}

/// Called by [isolateWork] to initialize the [DirectoryService] and optionally
/// the [TweetCache] before calling the [callback].
dynamic _isolateInit(List args) {
  try {
    initLogger(prefix: 'Isolate');
    _log.fine("initializing isolate");

    final Function callback = args[0];
    final message = args[1];

    if (args[2] is DirectoryServiceData) {
      DirectoryService.isolateInstance = DirectoryService.data(args[2]);
    }

    if (args[3] is TweetCacheData) {
      TweetCache.isolateInstance = TweetCache.data(
        directoryService: DirectoryService.isolateInstance,
        data: args[3],
      );
    }

    _log.fine("initialization done");
    // todo: if callback is future, await?
    return callback(message);
  } catch (e) {
    _log.severe("error in isolate: $e");
    return e;
  }
}
