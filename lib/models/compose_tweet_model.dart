import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/media_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/misc/flushbar.dart';
import 'package:harpy/core/utils/file_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';

/// The model for composing a new tweet.
class ComposeTweetModel extends ChangeNotifier {
  ComposeTweetModel({
    this.onTweeted,
  });

  final TweetService tweetService = app<TweetService>();
  final MediaService mediaService = app<MediaService>();

  static final Logger _log = Logger("ComposeTweetModel");

  /// The list of media files to upload with the tweet.
  final List<File> _media = [];
  List<File> get media => UnmodifiableListView(_media);

  /// A list of media file paths that were unable to be uploaded.
  final List<String> _badMedia = [];

  /// `true` while uploading the media and posting the tweet.
  bool _tweeting = false;
  bool get tweeting => _tweeting;

  /// A callback when a tweet has been successfully posted.
  VoidCallback onTweeted;

  /// Whether or not the [file] was unable to be uploaded.
  bool isBadFile(File file) => _badMedia.contains(file.path);

  /// Whether or not more media can be added.
  bool get canAddMedia {
    if (_tweeting || _media.length == 4) {
      return false;
    }

    if (_media.isEmpty) {
      return true;
    }

    final mediaFileExtensions =
        _media.map((media) => getFileExtension(media.path));

    return mediaFileExtensions.every((extension) =>
        ["jpg", "jpeg", "png", "webp"].contains(extension?.toLowerCase()));
  }

  /// Uploads all selected media files and creates a new tweet with the [text].
  Future<void> tweet(String text) async {
    _log
      ..fine("creating new tweet")
      ..fine("uploading ${_media.length} media files");

    _tweeting = true;
    notifyListeners();

    // wait to upload all media
    final List<String> mediaIds =
        await Future.wait(_media.map(mediaService.upload))
                .catchError(twitterClientErrorHandler) ??
            [null];

    if (mediaIds.every((mediaId) => mediaId != null)) {
      final tweet = await tweetService
          .updateStatus(
            text: text,
            mediaIds: mediaIds,
          )
          .catchError(twitterClientErrorHandler);

      // clear media
      _media.clear();

      if (onTweeted != null) {
        // call callback to clear the text
        onTweeted();
      }

      _log.fine("tweet created");
      // todo: add tweet to home timeline & update
    } else {
      // add the path of files that were unable to be uploaded to the list of
      // bad media
      _badMedia.clear();
      for (int i = 0; i < mediaIds.length; i++) {
        if (mediaIds[i] == null) {
          _badMedia.add(_media[i].path);
        }
      }

      // todo: show error message
//      showFlushbar(
//        "Unable to upload media",
//        type: FlushbarType.error,
//      );

      _log.warning("unable to upload at least one media file");
    }

    _tweeting = false;
    notifyListeners();
  }

  /// Adds a media file to be uploaded when posting the tweet.
  ///
  /// Only up to 4 images (jpg, png, webp) or 1 video / gif can be uploaded.
  Future<void> addMedia() async {
    final File media = await file_picker.FilePicker.getFile();

    if (media != null) {
      if (addMediaFileToList(media)) {
        notifyListeners();
      } else {
        showFlushbar(
          "Unable to add media\n"
          "Only 4 images or 1 gif / video allowed",
          type: FlushbarType.warning,
        );
      }
    }
  }

  @visibleForTesting
  bool addMediaFileToList(File media) {
    if (_validateMediaFile(media)) {
      _media.add(media);
      return true;
    } else {
      return false;
    }
  }

  /// Removes a media file from the list.
  void removeMedia(int index) {
    try {
      _media.removeAt(index);
      notifyListeners();
    } catch (e) {
      _log.warning("Tried to remove media that is not in the list");
    }
  }

  /// Validates whether or not a file can be added to the list of media.
  bool _validateMediaFile(File media) {
    if (_media.length >= 4) {
      return false;
    }

    final FileType type = getFileType(media);

    // unknown type
    if (type == null) {
      return false;
    }

    // valid if type is video or gif and no other media already added
    if (type == FileType.video || type == FileType.gif) {
      return _media.isEmpty;
    }

    // validate image type
    if (type == FileType.image) {
      final mediaFileExtensions = _media
          .followedBy([media]).map((media) => getFileExtension(media.path));

      return mediaFileExtensions.every((extension) =>
          ["jpg", "jpeg", "png", "webp"].contains(extension?.toLowerCase()));
    }

    return false;
  }
}
