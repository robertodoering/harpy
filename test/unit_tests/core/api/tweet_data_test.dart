import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';

void main() {
  group('replyAuthors', () {
    test('returns an empty string when no replies exist', () {
      final tweetData = TweetData.fromTweet(Tweet());

      expect(tweetData.replyAuthors, '');
    });

    test('finds and returns the display names of reply authors', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = TweetData.fromTweet(Tweet()).copyWith(
        replies: [
          TweetData.fromTweet(Tweet()..user = firstUser),
          TweetData.fromTweet(Tweet()..user = secondUser),
        ],
      );

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test('does not include duplicate reply authors names', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = TweetData.fromTweet(Tweet()).copyWith(
        replies: [
          TweetData.fromTweet(Tweet()..user = firstUser),
          TweetData.fromTweet(Tweet()..user = secondUser),
          TweetData.fromTweet(Tweet()..user = firstUser),
        ],
      );

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test(
        'ignores the name of the original tweets author if they are the only '
        'replier', () {
      final originalUser = User()..name = 'Original author';

      final tweetData = TweetData.fromTweet(
        Tweet()..user = originalUser,
      ).copyWith(
        replies: [
          TweetData.fromTweet(Tweet()..user = originalUser),
        ],
      );

      expect(tweetData.replyAuthors, '');
    });

    test('includes the original user if they are not the only replier', () {
      final originalUser = User()..name = 'Original author';

      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = TweetData.fromTweet(
        Tweet()..user = originalUser,
      ).copyWith(
        replies: [
          TweetData.fromTweet(Tweet()..user = originalUser),
          TweetData.fromTweet(Tweet()..user = firstUser),
          TweetData.fromTweet(Tweet()..user = secondUser),
        ],
      );

      expect(
        tweetData.replyAuthors,
        'Original author, First replier, Second replier',
      );
    });
  });
}
