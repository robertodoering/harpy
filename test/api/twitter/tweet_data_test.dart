import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';

void main() {
  group('replyAuthors', () {
    test('returns an empty string when no replies exist', () {
      final tweetData = LegacyTweetData.fromTweet(Tweet());

      expect(tweetData.replyAuthors, '');
    });

    test('finds and returns the display names of reply authors', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = LegacyTweetData.fromTweet(Tweet()).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = secondUser),
        ],
      );

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test('does not include duplicate reply authors names', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = LegacyTweetData.fromTweet(Tweet()).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = secondUser),
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
        ],
      );

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test(
        'ignores the name of the original tweets author if they are the only '
        'replier', () {
      final originalUser = User()..name = 'Original author';

      final tweetData = LegacyTweetData.fromTweet(
        Tweet()..user = originalUser,
      ).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = originalUser),
        ],
      );

      expect(tweetData.replyAuthors, '');
    });

    test('includes the original user if they are not the only replier', () {
      final originalUser = User()..name = 'Original author';

      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = LegacyTweetData.fromTweet(
        Tweet()..user = originalUser,
      ).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = originalUser),
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = secondUser),
        ],
      );

      expect(
        tweetData.replyAuthors,
        'Original author, First replier, Second replier',
      );
    });

    test('includes the author only once', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';

      final tweetData = LegacyTweetData.fromTweet(Tweet()).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = secondUser),
        ],
      );

      expect(
        tweetData.replyAuthors,
        'First replier, Second replier',
      );
    });

    test('includes only the first 5 authors when there are more', () {
      final firstUser = User()..name = 'First replier';
      final secondUser = User()..name = 'Second replier';
      final thirdUser = User()..name = 'Third replier';
      final fourthUser = User()..name = 'Fourth replier';
      final fifthUser = User()..name = 'Fifth replier';
      final sixthUser = User()..name = 'Sixth replier';
      final seventhUser = User()..name = 'Seventh replier';

      final tweetData = LegacyTweetData.fromTweet(Tweet()).copyWith(
        replies: [
          LegacyTweetData.fromTweet(Tweet()..user = firstUser),
          LegacyTweetData.fromTweet(Tweet()..user = secondUser),
          LegacyTweetData.fromTweet(Tweet()..user = thirdUser),
          LegacyTweetData.fromTweet(Tweet()..user = fourthUser),
          LegacyTweetData.fromTweet(Tweet()..user = fifthUser),
          LegacyTweetData.fromTweet(Tweet()..user = sixthUser),
          LegacyTweetData.fromTweet(Tweet()..user = seventhUser),
        ],
      );

      expect(
        tweetData.replyAuthors,
        'First replier, Second replier, Third replier, Fourth replier, '
        'Fifth replier and 2 more',
      );
    });
  });
}
