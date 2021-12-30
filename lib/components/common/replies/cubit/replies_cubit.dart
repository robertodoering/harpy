import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'replies_cubit.freezed.dart';

/// Handles loading replies for a tweet.
///
/// If the tweet itself is also a reply, the parent tweets will also be
/// requested.
class RepliesCubit extends Cubit<RepliesState> with HarpyLogger {
  RepliesCubit({
    required this.tweet,
  }) : super(const RepliesState.loading()) {
    request();
  }

  /// The original tweet which to show replies for.
  final TweetData tweet;

  Future<void> request() async {
    log.fine('loading replies for ${tweet.id}');

    emit(const RepliesState.loading());

    final results = await Future.wait([
      _loadAllParentTweets(tweet),
      _loadAllReplies(tweet),
    ]);

    final parent = results[0] is TweetData ? results[0] as TweetData : null;
    final replies = results[1] is BuiltList<TweetData>
        ? results[1] as BuiltList<TweetData>
        : null;

    if (replies != null) {
      if (replies.isNotEmpty) {
        log.fine('found ${replies.length} replies');

        emit(RepliesState.data(replies: replies, parent: parent));
      } else {
        log.fine('no replies found');

        emit(RepliesState.noData(parent: parent));
      }
    } else {
      log.fine('error requesting replies');

      emit(RepliesState.error(parent: parent));
    }
  }

  Future<TweetData?> _loadAllParentTweets(TweetData tweet) async {
    final parent = await _loadParent(tweet);

    if (parent != null) {
      log.fine('loading parent tweets');

      return _loadReplyChain(parent);
    } else {
      log.fine('no parent tweet exist');

      return null;
    }
  }

  Future<BuiltList<TweetData>?> _loadAllReplies(TweetData tweet) async {
    final result = await app<TwitterApi>()
        .tweetSearchService
        .findReplies(tweet)
        .handleError(twitterApiErrorHandler);

    if (result != null) {
      log.fine('found ${result.replies.length} replies');
      return result.replies.toBuiltList();
    } else {
      return null;
    }
  }

  /// Loads the parent of a single [tweet] if one exist.
  Future<TweetData?> _loadParent(TweetData tweet) async {
    if (tweet.hasParent) {
      final parent = await app<TwitterApi>()
          .tweetService
          .show(id: tweet.parentTweetId!)
          .then(TweetData.fromTweet)
          .handleError(silentErrorHandler);

      return parent;
    } else {
      return null;
    }
  }

  /// Loads all parents recursively and adds them as their [TweetData.replies].
  Future<TweetData> _loadReplyChain(TweetData tweet) async {
    final parent = await _loadParent(tweet);

    if (parent != null) {
      return _loadReplyChain(parent..replies = [tweet]);
    } else {
      return tweet;
    }
  }
}

@freezed
class RepliesState with _$RepliesState {
  const factory RepliesState.loading() = _Loading;

  const factory RepliesState.data({
    required BuiltList<TweetData> replies,

    /// When the tweet is a reply itself, the [parent] will contain the parent
    /// reply chain.
    final TweetData? parent,
  }) = _Data;

  const factory RepliesState.noData({final TweetData? parent}) = _NoData;
  const factory RepliesState.error({final TweetData? parent}) = _Error;
}

extension RepliesStateExtension on RepliesState {
  bool get hasParent => parent != null;

  TweetData? get parent => mapOrNull<TweetData?>(
        data: (value) => value.parent,
        noData: (value) => value.parent,
        error: (value) => value.parent,
      );

  BuiltList<TweetData> get replies => maybeMap(
        data: (value) => value.replies,
        orElse: BuiltList.new,
      );
}
