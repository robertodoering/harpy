part of 'tweet_bloc.dart';

@immutable
class TweetState extends Equatable {
  const TweetState({
    required this.tweet,
    this.isFavoriting = false,
    this.isRetweeting = false,
    this.isTranslating = false,
  });

  final TweetData tweet;

  final bool isFavoriting;
  final bool isRetweeting;
  final bool isTranslating;

  @override
  List<Object?> get props => [
        tweet,
        isFavoriting,
        isRetweeting,
        isTranslating,
      ];

  TweetState copyWith({
    TweetData? tweet,
    bool? isFavoriting,
    bool? isRetweeting,
    bool? isTranslating,
  }) {
    return TweetState(
      tweet: tweet ?? this.tweet,
      isFavoriting: isFavoriting ?? this.isFavoriting,
      isRetweeting: isRetweeting ?? this.isRetweeting,
      isTranslating: isTranslating ?? this.isTranslating,
    );
  }
}
