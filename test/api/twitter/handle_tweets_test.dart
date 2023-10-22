import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';

void main() {
  group('handle tweets', () {
    group('replies', () {
      test('adds a reply to the parent tweet if it exist in the list',
          () async {
        final tweets = await handleTweets([
          Tweet()
            ..idStr = '2'
            ..inReplyToStatusIdStr = '1',
          Tweet()..idStr = '1',
        ]);

        expect(tweets.length, equals(1));
        expect(tweets.single.id, equals('1'));
        expect(tweets.single.replies.length, equals(1));
        expect(tweets.single.replies.single.id, equals('2'));
      });

      test('adds multiple replies to the same parent tweet', () async {
        final tweets = await handleTweets([
          Tweet()
            ..idStr = '4'
            ..inReplyToStatusIdStr = '1',
          Tweet()
            ..idStr = '3'
            ..inReplyToStatusIdStr = '1',
          Tweet()
            ..idStr = '2'
            ..inReplyToStatusIdStr = '1',
          Tweet()..idStr = '1',
        ]);

        expect(tweets.length, equals(1));
        expect(tweets.single.id, equals('1'));
        expect(tweets.single.replies.length, equals(3));
      });

      test('handles multi-level reply chains', () async {
        final tweets = await handleTweets([
          Tweet()
            ..idStr = '5'
            ..inReplyToStatusIdStr = '4',
          Tweet()
            ..idStr = '4'
            ..inReplyToStatusIdStr = '3',
          Tweet()
            ..idStr = '3'
            ..inReplyToStatusIdStr = '2',
          Tweet()
            ..idStr = '2'
            ..inReplyToStatusIdStr = '1',
          Tweet()..idStr = '1',
        ]);

        expect(tweets.length, equals(1));
        expect(tweets.single.id, equals('1'));
        expect(tweets.single.replies.length, equals(1));
        expect(tweets.single.replies.single.id, equals('2'));
        expect(tweets.single.replies.single.replies.length, equals(1));
        expect(tweets.single.replies.single.replies.single.id, equals('3'));
        expect(
          tweets.single.replies.single.replies.single.replies.length,
          equals(1),
        );
        expect(
          tweets.single.replies.single.replies.single.replies.single.id,
          equals('4'),
        );
        expect(
          tweets.single.replies.single.replies.single.replies.single.replies
              .length,
          equals(1),
        );
        expect(
          tweets.single.replies.single.replies.single.replies.single.replies
              .single.id,
          equals('5'),
        );
      });
    });

    group('sorting', () {
      test('sorts the tweets based on their id', () async {
        final tweets = await handleTweets([
          Tweet()..idStr = '1',
          Tweet()..idStr = '3',
          Tweet()..idStr = '2',
        ]);

        expect(tweets.length, equals(3));
        expect(tweets[0].id, equals('3'));
        expect(tweets[1].id, equals('2'));
        expect(tweets[2].id, equals('1'));
      });

      test('the newest reply bumps the parent tweet', () async {
        final tweets = await handleTweets([
          Tweet()
            ..idStr = '6'
            ..inReplyToStatusIdStr = '2',
          Tweet()
            ..idStr = '5'
            ..inReplyToStatusIdStr = '1',
          Tweet()
            ..idStr = '4'
            ..inReplyToStatusIdStr = '2',
          Tweet()..idStr = '3',
          Tweet()..idStr = '2',
          Tweet()..idStr = '1',
        ]);

        expect(tweets.length, equals(3));
        expect(tweets[0].id, equals('2'));
        expect(tweets[1].id, equals('1'));
        expect(tweets[2].id, equals('3'));
      });

      test('sorts newest replies first for parent tweets with multiple replies',
          () async {
        final tweets = await handleTweets([
          Tweet()
            ..idStr = '4'
            ..inReplyToStatusIdStr = '1',
          Tweet()
            ..idStr = '3'
            ..inReplyToStatusIdStr = '1',
          Tweet()
            ..idStr = '2'
            ..inReplyToStatusIdStr = '1',
          Tweet()..idStr = '1',
        ]);

        expect(tweets.single.replies[0].id, equals('4'));
        expect(tweets.single.replies[1].id, equals('3'));
        expect(tweets.single.replies[2].id, equals('2'));
      });
    });
  });
}
