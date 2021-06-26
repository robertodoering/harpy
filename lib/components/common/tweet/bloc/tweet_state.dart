part of 'tweet_bloc.dart';

@immutable
class TweetState extends Equatable {
  const TweetState({
    this.isFavoriting = false,
    this.isRetweeting = false,
    this.isTranslating = false,
  });

  final bool isFavoriting;
  final bool isRetweeting;
  final bool isTranslating;

  @override
  List<Object?> get props => [
        isFavoriting,
        isRetweeting,
        isTranslating,
      ];

  TweetState copyWith({
    bool? isFavoriting,
    bool? isRetweeting,
    bool? isTranslating,
  }) {
    return TweetState(
      isFavoriting: isFavoriting ?? this.isFavoriting,
      isRetweeting: isRetweeting ?? this.isRetweeting,
      isTranslating: isTranslating ?? this.isTranslating,
    );
  }
}
