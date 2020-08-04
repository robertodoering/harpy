import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

void main() {
  group('replyAuthors', () {
    test('returns an empty string when no replies exist', () {
      final TweetData tweetData = TweetData.fromTweet(Tweet());

      expect(tweetData.replyAuthors, '');
    });

    test('finds and returns the display names of reply authors', () {
      final TweetData tweetData = TweetData.fromTweet(Tweet());

      final User firstUser = User()..name = 'First replier';
      final User secondUser = User()..name = 'Second replier';

      tweetData.replies.addAll(<TweetData>[
        TweetData.fromTweet(Tweet()..user = firstUser),
        TweetData.fromTweet(Tweet()..user = secondUser),
      ]);

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test('does not include duplicate reply authors names', () {
      final TweetData tweetData = TweetData.fromTweet(Tweet());

      final User firstUser = User()..name = 'First replier';
      final User secondUser = User()..name = 'Second replier';

      tweetData.replies.addAll(<TweetData>[
        TweetData.fromTweet(Tweet()..user = firstUser),
        TweetData.fromTweet(Tweet()..user = secondUser),
        TweetData.fromTweet(Tweet()..user = firstUser),
      ]);

      expect(tweetData.replyAuthors, 'First replier, Second replier');
    });

    test(
        'ignores the name of the orignial tweets author if they are the only '
        'replier', () {
      final User originalUser = User()..name = 'Original author';
      final TweetData tweetData = TweetData.fromTweet(
        Tweet()..user = originalUser,
      );

      tweetData.replies.addAll(<TweetData>[
        TweetData.fromTweet(Tweet()..user = originalUser),
      ]);

      expect(tweetData.replyAuthors, '');
    });

    test('includes the original user if they are not the only replier', () {
      final User originalUser = User()..name = 'Original author';
      final TweetData tweetData = TweetData.fromTweet(
        Tweet()..user = originalUser,
      );

      final User firstUser = User()..name = 'First replier';
      final User secondUser = User()..name = 'Second replier';

      tweetData.replies.addAll(<TweetData>[
        TweetData.fromTweet(Tweet()..user = originalUser),
        TweetData.fromTweet(Tweet()..user = firstUser),
        TweetData.fromTweet(Tweet()..user = secondUser),
      ]);

      expect(
        tweetData.replyAuthors,
        'Original author, First replier, Second replier',
      );
    });
  });
}
