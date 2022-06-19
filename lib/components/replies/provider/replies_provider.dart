import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'replies_provider.freezed.dart';

final repliesProvider = StateNotifierProvider.autoDispose
    .family<RepliesNotifier, RepliesState, TweetData>(
  (ref, tweet) => RepliesNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    tweet: tweet,
  ),
  name: 'RepliesProvider',
);

class RepliesNotifier extends StateNotifier<RepliesState> with LoggerMixin {
  RepliesNotifier({
    required Reader read,
    required TwitterApi twitterApi,
    required TweetData tweet,
  })  : _read = read,
        _twitterApi = twitterApi,
        _tweet = tweet,
        super(const RepliesState.loading()) {
    load();
  }

  final Reader _read;
  final TwitterApi _twitterApi;
  final TweetData _tweet;

  Future<void> load() async {
    log.fine('loading replies for ${_tweet.id}');

    state = const RepliesState.loading();

    final results = await Future.wait([
      _loadAllParentTweets(_tweet),
      _loadAllReplies(_tweet),
    ]);

    if (!mounted) return;

    final parent = results[0] as TweetData?;
    final replies = results[1] as BuiltList<TweetData>?;

    if (replies != null) {
      if (replies.isNotEmpty) {
        log.fine('found ${replies.length} replies');

        state = RepliesState.data(replies: replies, parent: parent);
      } else {
        log.fine('no replies found');

        if (mounted) state = RepliesState.noData(parent: parent);
      }
    } else {
      log.fine('error requesting replies');

      state = RepliesState.error(parent: parent);
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
    final result = await _twitterApi.tweetSearchService
        .findReplies(tweet)
        .handleError((e, st) => twitterErrorHandler(_read, e, st));

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
      final parent = await _twitterApi.tweetService
          .show(id: tweet.parentTweetId!)
          .then(TweetData.fromTweet)
          .handleError(logErrorHandler);

      return parent;
    } else {
      return null;
    }
  }

  /// Loads all parents recursively and adds them as their replies.
  Future<TweetData> _loadReplyChain(TweetData tweet) async {
    final parent = await _loadParent(tweet);

    return parent != null
        ? await _loadReplyChain(parent.copyWith(replies: [tweet]))
        : tweet;
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
