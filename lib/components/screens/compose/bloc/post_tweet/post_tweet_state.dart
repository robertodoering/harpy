part of 'post_tweet_bloc.dart';

abstract class PostTweetState extends Equatable {
  const PostTweetState({
    this.message,
    this.additionalInfo,
  });

  final String? message;
  final String? additionalInfo;

  @override
  List<Object?> get props => <Object?>[
        message,
        additionalInfo,
      ];

  /// Whether the state has a humanly readable message.
  bool get hasMessage => message != null;

  /// Whether additional info exists for this message.
  bool get hasAdditionalInfo => additionalInfo != null;

  /// Whether the tweet is currently being posted.
  bool get inProgress =>
      this is! TweetSuccessfullyPosted && this is! PostTweetErrorState;

  /// Whether the tweet has successfully been posted.
  bool get postingSuccessful => this is TweetSuccessfullyPosted;

  /// Whether posting the tweet failed.
  bool get postingFailed => this is PostTweetErrorState;
}

class PostTweetInitial extends PostTweetState {
  const PostTweetInitial();
}

class ConvertingTweetVideo extends PostTweetState {
  const ConvertingTweetVideo()
      : super(
          message: 'preparing video...',
          additionalInfo: 'this may take a moment',
        );
}

class UploadingTweetMedia extends PostTweetState {
  UploadingTweetMedia({
    required int index,
    required bool multiple,
    required MediaType? type,
  }) : super(
          message: _messageFromType(type, index, multiple),
          additionalInfo: 'this may take a moment',
        );

  static String _messageFromType(MediaType? type, int index, bool multiple) {
    switch (type) {
      case MediaType.image:
        return multiple
            ? 'uploading ${(index + 1).toOrdinalNumerical()} image...'
            : 'uploading image...';
      case MediaType.gif:
        return 'uploading gif...';
      case MediaType.video:
        return 'uploading video...';
      case null:
        return 'uploading media...';
    }
  }
}

class TweetMediaSuccessfullyUploaded extends PostTweetState {
  const TweetMediaSuccessfullyUploaded({
    required String? previousMessage,
    required String? previousAdditionalInfo,
    required this.mediaIds,
  }) : super(
          message: previousMessage,
          additionalInfo: previousAdditionalInfo,
        );

  final List<String> mediaIds;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        mediaIds,
      ];
}

class PostingTweet extends PostTweetState {
  const PostingTweet()
      : super(
          message: 'sending tweet...',
        );
}

class TweetSuccessfullyPosted extends PostTweetState {
  const TweetSuccessfullyPosted({
    required this.tweet,
  }) : super(
          message: 'tweet successfully sent!',
        );

  final TweetData tweet;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        tweet,
      ];
}

abstract class PostTweetErrorState extends PostTweetState {
  const PostTweetErrorState({
    String? message,
    String? additionalInfo,
  }) : super(
          message: message,
          additionalInfo: additionalInfo,
        );
}

class ConvertingTweetVideoError extends PostTweetErrorState {
  const ConvertingTweetVideoError()
      : super(
          message: 'error preparing video',
          additionalInfo: 'the video format may not be supported',
        );
}

class UploadingTweetMediaError extends PostTweetErrorState {
  const UploadingTweetMediaError()
      : super(
          message: 'error uploading media',
        );
}

class PostingTweetError extends PostTweetErrorState {
  const PostingTweetError({
    String? errorMessage,
  }) : super(
          message: 'error sending tweet',
          additionalInfo: errorMessage != null
              ? 'twitter error message:\n'
                  '$errorMessage'
              : null,
        );
}
