import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/utils/list_utils.dart';
import 'package:logging/logging.dart';
import 'package:mime_type/mime_type.dart';

class MediaService {
  MediaService({
    @required this.twitterClient,
  }) : assert(twitterClient != null);

  final TwitterClient twitterClient;

  static final Logger _log = Logger("MediaService");

  static const _maxChunkSize = 500000;

  /// Uploads a media file to twitter that can be used when composing a tweet
  /// to add up to 4 images or 1 gif / video to the tweet.
  ///
  /// Supported image media types: JPG, PNG, GIF, WEBP.
  /// Image size <= 5 MB, animated GIF size <= 15 MB.
  Future<TwitterMedia> upload({
    @required File media,
  }) async {
    _log.fine("uploading media");

    final List<int> mediaBytes = media.readAsBytesSync();
    final int totalBytes = mediaBytes.length;
    final String mediaType = mime(media.path);

    final String mediaId = await _initUpload(
      totalBytes: totalBytes,
      mediaType: mediaType,
    );

    _log.finer("received media id $mediaId");

    final List<List<int>> mediaChunks = splitList<int>(
      mediaBytes,
      _maxChunkSize,
    );

    _log.fine("uploading media in ${mediaChunks.length} chunks");

    for (int i = 0; i < mediaChunks.length; i++) {
      final List<int> chunk = mediaChunks[i];

      await _appendUpload(mediaId: mediaId, mediaData: chunk, segmentIndex: i);
    }

    return _finalizeUpload(mediaId: mediaId);
  }

  /// Requests to initiate a file upload session and returns a media id on
  /// success.
  Future<String> _initUpload({
    @required int totalBytes,
    @required String mediaType,
  }) async {
    final body = <String, String>{
      "command": "INIT",
      "total_bytes": "$totalBytes",
      "media_type": mediaType,
    };
    _log
      ..fine("initializing file upload")
      ..finer("$totalBytes bytes for file of type $mediaType");

    return twitterClient
        .post(
          "https://upload.twitter.com/1.1/media/upload.json",
          body: body,
        )
        .then((response) => jsonDecode(response.body)["media_id_string"]);
  }

  /// Uploads the media file in chunks.
  Future<void> _appendUpload({
    @required String mediaId,
    @required List<int> mediaData,
    @required int segmentIndex,
  }) async {
    _log
      ..fine("appending media data to upload")
      ..finer("segment $segmentIndex with ${mediaData.length} bytes");

    final params = <String, dynamic>{
      "command": "APPEND",
      "media_id": mediaId,
      "segment_index": "$segmentIndex",
    };

    await twitterClient.multipartRequest(
      "https://upload.twitter.com/1.1/media/upload.json",
      params: params,
      fileBytes: mediaData,
    );
  }

  /// Finalizes the upload session after a media file has been uploaded
  /// successfully.
  Future<TwitterMedia> _finalizeUpload({
    @required String mediaId,
  }) async {
    _log.fine("finalizing upload for $mediaId");

    final body = <String, String>{
      "command": "FINALIZE",
      "media_id": mediaId,
    };

    return twitterClient
        .post(
          "https://upload.twitter.com/1.1/media/upload.json",
          body: body,
        )
        .then((response) => TwitterMedia.fromJson(jsonDecode(response.body)));
  }

  /// Returns whether or not the file is too big to be uploaded.
//  bool _validateSize(int bytes, String mediaType) {
//    if (mediaType == "image/gif" || mediaType.contains("video/")) {
//      return bytes <= 1.5e+7;
//    } else {
//      return bytes <= 5e+6;
//    }
//  }
}
