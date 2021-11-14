import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';

// TODO: refactor into cubit

/// Contains a list of entries for the [MediaTimelineModel].
///
/// Each entry represents one image, gif or video that is mapped to its
/// [TweetData].
class MediaTimelineModel extends ValueNotifier<List<MediaTimelineEntry>> {
  MediaTimelineModel({
    required List<TweetData> initialTweets,
  }) : super(<MediaTimelineEntry>[]) {
    updateEntries(initialTweets);
  }

  void updateEntries(List<TweetData> tweets) {
    value = _entriesFromTweets(tweets);
  }

  /// Whether tweets with [MediaData] exist for the media timeline model.
  bool get hasEntries => value.isNotEmpty;

  List<MediaTimelineEntry> _entriesFromTweets(List<TweetData> tweets) {
    final newEntries = <MediaTimelineEntry>[];

    for (final tweet in tweets) {
      if (tweet.hasImages) {
        for (final image in tweet.images!) {
          if (!_containsMedia(newEntries, image)) {
            newEntries.add(
              MediaTimelineEntry(
                tweet: tweet,
                media: image,
              ),
            );
          }
        }
      } else if (tweet.hasGif) {
        if (!_containsMedia(newEntries, tweet.gif)) {
          newEntries.add(MediaTimelineEntry(tweet: tweet, media: tweet.gif));
        }
      } else if (tweet.hasVideo) {
        if (!_containsMedia(newEntries, tweet.video)) {
          newEntries.add(MediaTimelineEntry(tweet: tweet, media: tweet.video));
        }
      }
    }

    return newEntries;
  }

  bool _containsMedia(List<MediaTimelineEntry> entries, MediaData? media) {
    return entries.any(
      (entry) => entry.media!.appropriateUrl == media!.appropriateUrl,
    );
  }
}

/// An entry for a media timeline that maps a [TweetData] to its [MediaData].
///
/// A single tweet might have multiple media data (i.e. more than one image).
class MediaTimelineEntry {
  const MediaTimelineEntry({
    required this.tweet,
    required this.media,
  });

  final TweetData tweet;
  final MediaData? media;

  bool get isImage => tweet.hasImages;
  bool get isGif => tweet.hasGif;
  bool get isVideo => tweet.hasVideo;

  ImageData? get imageData => media is ImageData ? media as ImageData? : null;
  VideoData? get videoData => media is VideoData ? media as VideoData? : null;
}
