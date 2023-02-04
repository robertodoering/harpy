import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/compose/post_tweet/preferences/post_tweet_preferences.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:humanizer/humanizer.dart';
import 'package:rby/rby.dart';

part 'post_tweet_provider.freezed.dart';

final postTweetProvider =
    StateNotifierProvider<PostTweetNotifier, PostTweetState>(
  (ref) => PostTweetNotifier(
    ref: ref,
    twitterApi: ref.watch(twitterApiV1Provider),
  ),
  name: 'PostTweetProvider',
);

class PostTweetNotifier extends StateNotifier<PostTweetState> with LoggerMixin {
  PostTweetNotifier({
    required Ref ref,
    required TwitterApi twitterApi,
  })  : _ref = ref,
        _twitterApi = twitterApi,
        super(const PostTweetState.inProgress());

  final Ref _ref;
  final TwitterApi _twitterApi;

  Future<void> post(
    String text, {
    /// The tweet hyperlink of the quoted tweet if this tweet is a quote.
    String? attachmentUrl,

    /// The id of the parent tweet if this tweet is a reply.
    String? inReplyToStatusId,
    BuiltList<PlatformFile>? media,
    MediaType? mediaType,
  }) async {
    List<String>? mediaIds;

    await _verifyMentionsConnections(text);
    if (state is PostTweetError) return;

    if (media != null && media.isNotEmpty && mediaType != null) {
      mediaIds = await _uploadmedia(media, mediaType);

      if (state is PostTweetError) return;
    }

    log.fine('posting tweet');

    state = const PostTweetState.inProgress(message: 'posting tweet...');

    String? additionalInfo;

    final status = await _twitterApi.tweetService
        .update(
          status: text,
          mediaIds: mediaIds,
          attachmentUrl: attachmentUrl,
          inReplyToStatusId: inReplyToStatusId,
          autoPopulateReplyMetadata: true,
        )
        .then(LegacyTweetData.fromTweet)
        .handleError((e, st) {
      if (e is Response) {
        final message = _responseErrorMessage(e.body);
        log.info(
          'handling error while sending status with message $message',
          e,
        );
        additionalInfo = message;
      } else {
        logErrorHandler(e, st);
      }
    });

    if (status != null) {
      state = PostTweetState.success(
        message: 'tweet sent successfully!',
        tweet: status,
      );
    } else {
      state = PostTweetState.error(
        message: 'error sending tweet',
        additionalInfo: additionalInfo != null
            ? 'Twitter error message:\n'
                '$additionalInfo'
            : null,
      );
    }
  }

  Future<void> _verifyMentionsConnections(String text) async {
    state = const PostTweetState.inProgress();

    final mentions = mentionRegex
        .allMatches(text)
        .map((match) => removePrependedSymbol(match.group(0), ['@']))
        .whereType<String>()
        .toList();

    if (mentions.isEmpty) return;

    try {
      final friendships = await _twitterApi.userService
          .friendshipsLookup(screenNames: mentions);

      final unrelatedMentionsCount = friendships
          .map((friendship) => friendship.connections ?? <String>[])
          .where(
            (connections) =>
                !connections.contains('following') &&
                !connections.contains('followed_by'),
          )
          .length;

      final valid = _ref
          .read(postTweetPreferencesProvider.notifier)
          .addAndVerifyUnrelatedMentions(unrelatedMentionsCount);

      if (!valid) {
        state = const PostTweetState.error(
          message: 'more than 5 mentions to unrelated users in the past 24h',
          additionalInfo: 'Twitter limits the amount of times you can '
              '@mention users that you have no connection to.\n'
              'Please wait a bit before mentioning other users in your Tweet',
        );
      }
    } catch (e, st) {
      logErrorHandler(e, st);

      state = const PostTweetState.error(
        message: 'error posting tweet',
        additionalInfo: 'Please try again later.',
      );
    }
  }

  Future<List<String>?> _uploadmedia(
    BuiltList<PlatformFile> media,
    MediaType type,
  ) async {
    log.fine('uploading media');

    final mediaFiles = <File>[];
    final mediaIds = <String>[];

    if (type == MediaType.video) {
      state = const PostTweetState.inProgress(
        message: 'preparing video...',
        additionalInfo: 'this may take a moment',
      );

      final converted = await _ref.read(mediaVideoConverter).convertVideo(
            media.single.path,
            media.single.extension,
          );

      if (converted != null) {
        mediaFiles.add(converted);
      } else {
        state = const PostTweetState.error(
          message: 'error preparing video',
          additionalInfo: 'The video format may not be supported.',
        );
      }
    } else {
      mediaFiles.addAll(media.map((media) => File(media.path!)));
    }

    try {
      for (var i = 0; i < mediaFiles.length; i++) {
        state = PostTweetState.inProgress(
          message: type.asMessage(i, mediaFiles.length > 1),
          additionalInfo: 'this may take a moment',
        );

        final mediaId = await _ref.read(mediaUploadService).upload(
              mediaFiles[i],
              type: type,
            );

        if (mediaId != null) mediaIds.add(mediaId);
      }

      log.fine('${mediaIds.length} media uploaded');
      return mediaIds;
    } catch (e, st) {
      log.severe('error while uploading media', e, st);

      state = const PostTweetState.error(message: 'error uploading media');

      return null;
    }
  }
}

@freezed
class PostTweetState with _$PostTweetState {
  const factory PostTweetState.inProgress({
    String? message,
    String? additionalInfo,
  }) = PostTweetInProgress;

  const factory PostTweetState.success({
    required LegacyTweetData tweet,
    String? message,
    String? additionalInfo,
  }) = PostTweetSuccess;

  const factory PostTweetState.error({
    String? message,
    String? additionalInfo,
  }) = PostTweetError;
}

extension PostTweetStateExtension on PostTweetState {
  LegacyTweetData? get tweet => maybeMap(
        success: (value) => value.tweet,
        orElse: () => null,
      );
}

extension on MediaType {
  String asMessage(int index, bool multiple) {
    switch (this) {
      case MediaType.image:
        return multiple
            ? 'uploading ${(index + 1).toOrdinalNumerical()} image...'
            : 'uploading image...';
      case MediaType.gif:
        return 'uploading gif...';
      case MediaType.video:
        return 'uploading video...';
    }
  }
}

/// Returns the error message of an error response or `null` if the error was
/// unable to be parsed.
///
/// Example response:
/// {"errors":[{"code":324,"message":"Duration too long, maximum:30000,
/// actual:30528 (MediaId: snf:1338982061273714688)"}]}
String? _responseErrorMessage(String body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final errors = json['errors'] as List<dynamic>;
    return (errors[0] as Map<String, dynamic>)['message'] as String;
  } catch (e, st) {
    logErrorHandler(e, st);
    return null;
  }
}
