import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'tweet_data.freezed.dart';

// TODO: create domain model for v2 response

@freezed
class TweetData with _$TweetData {
  const factory TweetData({
    required String id,
    required String text,
  }) = _TweetData;

  factory TweetData.fromV2(v2.TweetData tweet) {
    return TweetData(
      id: tweet.id,
      text: tweet.text,
    );
  }
}
