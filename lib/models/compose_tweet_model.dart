import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/media_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/misc/flushbar.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:logging/logging.dart';

/// The model for composing a new tweet.
class ComposeTweetModel extends ChangeNotifier {
  ComposeTweetModel({
    @required this.tweetService,
    @required this.mediaService,
    this.onTweeted,
  })  : assert(tweetService != null),
        assert(mediaService != null);

  final TweetService tweetService;
  final MediaService mediaService;

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
  bool isBadFile(File file) => _media.contains(file.path);

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
            [];

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

      _log.warning("unable to upload at least one media file");
    }

    _tweeting = false;
    notifyListeners();
  }

  /// Adds a media file to be uploaded when posting the tweet.
  ///
  /// Only up to 4 images (jpg, png, webp) or 1 video / gif can be uploaded.
  Future<void> addMedia() async {
    final File media = await FilePicker.getFile();

    if (media != null) {
      final validImage = _media.length < 4 &&
          _media
              .followedBy([media])
              .map((media) => getFileExtension(media.path))
              .every((extension) => ["jpg", "jpeg", "png", "webp"]
                  .contains(extension?.toLowerCase()));

      if (_media.isEmpty || validImage) {
        _media.add(media);
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

  /// Removes a media file from the list.
  void removeMedia(int index) {
    try {
      _media.removeAt(index);
      notifyListeners();
    } catch (e) {
      _log.warning("Tried to remove media that is not in the list");
    }
  }
}
