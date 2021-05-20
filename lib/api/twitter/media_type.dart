/// The [MediaType] as it is returned in from twitter.
const String kMediaPhoto = 'photo';
const String kMediaVideo = 'video';
const String kMediaGif = 'animated_gif';

/// The type of media that can be attached to a tweet.
enum MediaType {
  image,
  gif,
  video,
}

extension MediaTypeExtension on MediaType {
  /// The human readable name of the type.
  String get name {
    switch (this) {
      case MediaType.gif:
        return 'gif';
      case MediaType.video:
        return 'video';
      case MediaType.image:
        return 'image';
    }
  }
}
