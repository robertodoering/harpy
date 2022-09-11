import 'package:harpy/components/components.dart';

class TweetCardConfig {
  const TweetCardConfig({
    required this.elements,
    this.actions = const {},
    this.styles = const {},
  });

  final Set<TweetCardElement> elements;
  final Set<TweetCardActionElement> actions;
  final Map<TweetCardElement, TweetCardElementStyle> styles;

  TweetCardConfig copyWith({
    Set<TweetCardElement>? elements,
    Set<TweetCardActionElement>? actions,
    Map<TweetCardElement, TweetCardElementStyle>? styles,
  }) {
    return TweetCardConfig(
      elements: elements ?? this.elements,
      actions: actions ?? this.actions,
      styles: styles ?? this.styles,
    );
  }
}

const kDefaultTweetCardConfig = TweetCardConfig(
  elements: {
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
    TweetCardElement.linkPreview,
  },
  actions: {
    TweetCardActionElement.retweet,
    TweetCardActionElement.favorite,
    TweetCardActionElement.showReplies,
    TweetCardActionElement.spacer,
    TweetCardActionElement.translate,
  },
);

const kDefaultTweetCardQuoteConfig = TweetCardConfig(
  elements: {
    TweetCardElement.avatar,
    TweetCardElement.name,
    TweetCardElement.handle,
    TweetCardElement.text,
    TweetCardElement.translation,
    TweetCardElement.media,
    TweetCardElement.actionsButton,
  },
  styles: {
    TweetCardElement.avatar: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.name: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.handle: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.text: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.translation: TweetCardElementStyle(sizeDelta: -2),
    TweetCardElement.actionsButton: TweetCardElementStyle(sizeDelta: -2),
  },
);
