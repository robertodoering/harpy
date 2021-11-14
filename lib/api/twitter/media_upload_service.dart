import 'dart:io';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:mime_type/mime_type.dart';

class MediaUploadService {
  const MediaUploadService();

  static const _maxChunkSize = 500000;

  /// Uploads a media file to Twitter.
  ///
  /// Returns the `mediaId` string that can be used when composing a Tweet.
  /// Returns `null` if the [media] file is invalid.
  ///
  /// Throws an exception when a request returns an error or times out.
  Future<String?> upload(
    File media, {
    MediaType? type,
  }) async {
    final mediaBytes = media.readAsBytesSync();
    final totalBytes = mediaBytes.length;
    final mediaType = mime(media.path);

    if (totalBytes == 0 || mediaType == null) {
      // unknown type or empty file
      return null;
    }

    // initialize the upload
    final uploadInit = await app<TwitterApi>().mediaService.uploadInit(
          totalBytes: totalBytes,
          mediaType: mediaType,
          mediaCategory: mediaCategoryFromType(type),
        );

    final mediaId = uploadInit.mediaIdString!;

    // `splitList` splits the media bytes into lists with the max length of
    // 500000 (the max chunk size in bytes)
    final mediaChunks = splitList(
      mediaBytes,
      _maxChunkSize,
    );

    // upload each chunk
    for (var i = 0; i < mediaChunks.length; i++) {
      final chunk = mediaChunks[i];

      await app<TwitterApi>().mediaService.uploadAppend(
            mediaId: mediaId,
            media: chunk,
            segmentIndex: i,
          );
    }

    // finalize the upload
    final uploadFinalize = await app<TwitterApi>().mediaService.uploadFinalize(
          mediaId: mediaId,
        );

    if (uploadFinalize.processingInfo?.pending ?? false) {
      // asynchronous upload of media
      // we have to wait until twitter has processed the upload
      final finishedStatus = await _waitForUploadCompletion(
        mediaId: mediaId,
        sleep: uploadFinalize.processingInfo!.checkAfterSecs!,
      );

      return finishedStatus?.mediaIdString;
    }

    // media has been uploaded and processed

    return uploadFinalize.mediaIdString;
  }

  /// Concurrently requests the status of an upload until the uploaded
  /// succeeded and waits the suggested time between each call.
  ///
  /// Returns `null` if the upload failed.
  Future<UploadStatus?> _waitForUploadCompletion({
    required String mediaId,
    required int sleep,
  }) async {
    await Future<void>.delayed(Duration(seconds: sleep));

    final uploadStatus = await app<TwitterApi>().mediaService.uploadStatus(
          mediaId: mediaId,
        );

    if (uploadStatus.processingInfo != null &&
        uploadStatus.processingInfo!.succeeded) {
      // upload processing has succeeded
      return uploadStatus;
    } else if (uploadStatus.processingInfo != null &&
        uploadStatus.processingInfo!.inProgress) {
      // upload is still processing, need to wait longer
      return _waitForUploadCompletion(
        mediaId: mediaId,
        sleep: uploadStatus.processingInfo!.checkAfterSecs!,
      );
    } else {
      return null;
    }
  }
}
