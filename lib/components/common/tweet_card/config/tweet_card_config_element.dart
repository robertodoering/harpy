import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

enum TweetCardElement {
  topRow,
  retweeter,
  avatar,
  name,
  handle,
  text,
  translation,
  quote,
  media,
  actionsButton,
  actionsRow,
  details,
}

extension TweetCardElementExtension on TweetCardElement {
  bool shouldBuild(TweetData tweet, TweetCardConfig config) {
    if (config.elements.contains(this)) {
      switch (this) {
        case TweetCardElement.retweeter:
          return tweet.isRetweet;
        case TweetCardElement.text:
          return tweet.hasText;
        case TweetCardElement.quote:
          return tweet.hasQuote;
        case TweetCardElement.media:
          return tweet.hasMedia;
        case TweetCardElement.topRow:
        case TweetCardElement.translation:
        case TweetCardElement.actionsButton:
        case TweetCardElement.actionsRow:
        case TweetCardElement.avatar:
        case TweetCardElement.name:
        case TweetCardElement.handle:
        case TweetCardElement.details:
          return true;
      }
    } else {
      return false;
    }
  }

  /// Whether the element requires padding to be builds around it.
  bool get requiresPadding {
    switch (this) {
      case TweetCardElement.retweeter:
      case TweetCardElement.avatar:
      case TweetCardElement.name:
      case TweetCardElement.handle:
      case TweetCardElement.text:
      case TweetCardElement.quote:
      case TweetCardElement.media:
      case TweetCardElement.details:
        return true;
      case TweetCardElement.translation:
      case TweetCardElement.topRow:
      case TweetCardElement.actionsButton:
      case TweetCardElement.actionsRow:
        return false;
    }
  }

  /// Build padding below when:
  /// * this element requires padding and
  /// * this is the last element or the next element also requires padding
  bool buildBottomPadding(int index, Iterable<TweetCardElement> elements) {
    return requiresPadding &&
        (index == elements.length - 1 ||
            elements.elementAt(index + 1).requiresPadding);
  }

  TweetCardElementStyle style(TweetCardConfig config) {
    return config.styles[this] ?? TweetCardElementStyle.empty;
  }
}

class TweetCardElementStyle {
  const TweetCardElementStyle({
    this.sizeDelta = 0,
  });

  static const TweetCardElementStyle empty = TweetCardElementStyle();

  final double sizeDelta;
}
