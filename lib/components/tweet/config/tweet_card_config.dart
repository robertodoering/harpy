import 'package:harpy/components/components.dart';

class TweetCardConfig {
  const TweetCardConfig({
    required this.elements,
    this.styles = const {},
  });

  final List<TweetCardElement> elements;
  final Map<TweetCardElement, TweetCardElementStyle> styles;

  TweetCardConfig copyWith({
    List<TweetCardElement>? elements,
    Map<TweetCardElement, TweetCardElementStyle>? styles,
  }) {
    return TweetCardConfig(
      elements: elements ?? this.elements,
      styles: styles ?? this.styles,
    );
  }
}

const kDefaultTweetCardConfig = TweetCardConfig(
  elements: [
    TweetCardElement.retweeter,
    TweetCardElement.avatar,
    TweetCardElement.name,
    TweetCardElement.handle,
    TweetCardElement.text,
    TweetCardElement.translation,
    TweetCardElement.quote,
    TweetCardElement.media,
    TweetCardElement.actionsButton,
    TweetCardElement.actionsRow,
  ],
);

const kDefaultTweetCardQuoteConfig = TweetCardConfig(
  elements: [
    TweetCardElement.avatar,
    TweetCardElement.name,
    TweetCardElement.handle,
    TweetCardElement.text,
    TweetCardElement.translation,
    TweetCardElement.media,
    TweetCardElement.actionsButton,
  ],
  styles: {
    TweetCardElement.avatar: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.name: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.handle: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.text: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.translation: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.actionsButton: TweetCardElementStyle(sizeDelta: -2),
  },
);
