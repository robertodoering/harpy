import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'replies_provider.freezed.dart';

final repliesProvider = StateNotifierProvider.autoDispose
    .family<RepliesNotifier, RepliesState, LegacyTweetData>(
  (ref, tweet) => RepliesNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
    tweet: tweet,
  ),
  name: 'RepliesProvider',
);

class RepliesNotifier extends StateNotifier<RepliesState> with LoggerMixin {
  RepliesNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
    required LegacyTweetData tweet,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        _tweet = tweet,
        super(const RepliesState.loading()) {
    load();
  }

  final Ref _ref;
  final TwitterApi _twitterApi;
  final LegacyTweetData _tweet;

  Future<void> load() async {
    log.fine('loading replies for ${_tweet.id}');

    state = const RepliesState.loading();

    final results = await Future.wait([
      _loadAllParentTweets(_tweet),
      _loadAllReplies(_tweet),
    ]);

    if (!mounted) return;

    final parent = results[0] as LegacyTweetData?;
    final replies = results[1] as BuiltList<LegacyTweetData>?;

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

  Future<LegacyTweetData?> _loadAllParentTweets(LegacyTweetData tweet) async {
    final parent = await _loadParent(tweet);

    if (parent != null) {
      log.fine('loading parent tweets');

      return _loadReplyChain(parent);
    } else {
      log.fine('no parent tweet exist');

      return null;
    }
  }

  Future<BuiltList<LegacyTweetData>?> _loadAllReplies(
    LegacyTweetData tweet,
  ) async {
    final result = await _twitterApi.tweetSearchService
        .findReplies(tweet)
        .handleError((e, st) => twitterErrorHandler(_ref, e, st));

    if (result != null) {
      log.fine('found ${result.replies.length} replies');
      return result.replies.toBuiltList();
    } else {
      return null;
    }
  }

  /// Loads the parent of a single [tweet] if one exist.
  Future<LegacyTweetData?> _loadParent(LegacyTweetData tweet) async {
    if (tweet.hasParent) {
      final parent = await _twitterApi.tweetService
          .show(id: tweet.parentTweetId!)
          .then(LegacyTweetData.fromTweet)
          .handleError(logErrorHandler);

      return parent;
    } else {
      return null;
    }
  }

  /// Loads all parents recursively and adds them as their replies.
  Future<LegacyTweetData> _loadReplyChain(LegacyTweetData tweet) async {
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
    required BuiltList<LegacyTweetData> replies,

    /// When the tweet is a reply itself, the [parent] will contain the parent
    /// reply chain.
    final LegacyTweetData? parent,
  }) = _Data;

  const factory RepliesState.noData({final LegacyTweetData? parent}) = _NoData;
  const factory RepliesState.error({final LegacyTweetData? parent}) = _Error;
}

extension RepliesStateExtension on RepliesState {
  LegacyTweetData? get parent => mapOrNull<LegacyTweetData?>(
        data: (value) => value.parent,
        noData: (value) => value.parent,
        error: (value) => value.parent,
      );

  BuiltList<LegacyTweetData> get replies => maybeMap(
        data: (value) => value.replies,
        orElse: BuiltList.new,
      );
}
