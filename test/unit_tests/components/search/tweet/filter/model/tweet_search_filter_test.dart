import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';

void main() {
  group('tweet search filter', () {
    test('builds an empty query with an empty filter', () {
      const filter = TweetSearchFilter.empty;

      expect(filter.buildQuery(), equals(''));
    });

    test('builds query with tweet author filter', () {
      const filter = TweetSearchFilter(
        tweetAuthor: 'harpy_app',
      );

      expect(filter.buildQuery(), equals('from:harpy_app'));
    });

    test('builds query with replying to filter', () {
      const filter = TweetSearchFilter(
        replyingTo: 'harpy_app',
      );

      expect(filter.buildQuery(), equals('to:harpy_app'));
    });

    test('builds query with includesPhrases filter', () {
      const filter1 = TweetSearchFilter(
        includesPhrases: ['cat'],
      );

      const filter2 = TweetSearchFilter(
        includesPhrases: ['cute', 'cat'],
      );

      const filter3 = TweetSearchFilter(
        includesPhrases: ['cute cat', 'petting'],
      );

      expect(filter1.buildQuery(), equals('cat'));
      expect(filter2.buildQuery(), equals('cute cat'));
      expect(filter3.buildQuery(), equals('"cute cat" petting'));
    });

    test('builds query with includesHashtags filter', () {
      const filter1 = TweetSearchFilter(
        includesHashtags: ['#cute'],
      );

      const filter2 = TweetSearchFilter(
        includesHashtags: ['#cute', '#cat'],
      );

      expect(filter1.buildQuery(), equals('#cute'));
      expect(filter2.buildQuery(), equals('#cute #cat'));
    });

    test('builds query with includesMentions filter', () {
      const filter1 = TweetSearchFilter(
        includesMentions: ['@harpy_app'],
      );

      const filter2 = TweetSearchFilter(
        includesHashtags: ['@harpy_app', '@NASA'],
      );

      expect(filter1.buildQuery(), equals('@harpy_app'));
      expect(filter2.buildQuery(), equals('@harpy_app @NASA'));
    });

    test('builds query with includesUrls filter', () {
      const filter1 = TweetSearchFilter(
        includesUrls: ['google'],
      );

      const filter2 = TweetSearchFilter(
        includesUrls: ['google', 'github'],
      );

      expect(filter1.buildQuery(), equals('url:google'));
      expect(filter2.buildQuery(), equals('url:google url:github'));
    });

    test('builds query with includesRetweets filter', () {
      const filter = TweetSearchFilter(
        includesRetweets: true,
      );

      expect(filter.buildQuery(), equals('filter:retweets'));
    });

    test('builds query with includesImages filter', () {
      const filter = TweetSearchFilter(
        includesImages: true,
      );

      expect(filter.buildQuery(), equals('filter:images'));
    });

    test('builds query with includesVideo filter', () {
      const filter = TweetSearchFilter(
        includesVideo: true,
      );

      expect(filter.buildQuery(), equals('filter:native_video'));
    });

    test('builds query with includesImages & includesVideo filter', () {
      const filter = TweetSearchFilter(
        includesImages: true,
        includesVideo: true,
      );

      expect(filter.buildQuery(), equals('filter:media'));
    });

    test('builds query with excludesPhrases filter', () {
      const filter1 = TweetSearchFilter(
        excludesPhrases: ['cat'],
      );

      const filter2 = TweetSearchFilter(
        excludesPhrases: ['cute', 'cat'],
      );

      const filter3 = TweetSearchFilter(
        excludesPhrases: ['cute cat', 'petting'],
      );

      expect(filter1.buildQuery(), equals('-cat'));
      expect(filter2.buildQuery(), equals('-cute -cat'));
      expect(filter3.buildQuery(), equals('-"cute cat" -petting'));
    });

    test('builds query with excludesHashtags filter', () {
      const filter1 = TweetSearchFilter(
        excludesHashtags: ['-#cute'],
      );

      const filter2 = TweetSearchFilter(
        excludesHashtags: ['-#cute', '-#cat'],
      );

      expect(filter1.buildQuery(), equals('-#cute'));
      expect(filter2.buildQuery(), equals('-#cute -#cat'));
    });

    test('builds query with excludesMentions filter', () {
      const filter1 = TweetSearchFilter(
        excludesMentions: ['-@harpy_app'],
      );

      const filter2 = TweetSearchFilter(
        excludesMentions: ['-@harpy_app', '-@NASA'],
      );

      expect(filter1.buildQuery(), equals('-@harpy_app'));
      expect(filter2.buildQuery(), equals('-@harpy_app -@NASA'));
    });

    test('builds query with excludesRetweets filter', () {
      const filter = TweetSearchFilter(
        excludesRetweets: true,
      );

      expect(filter.buildQuery(), equals('-filter:retweets'));
    });

    test('builds query with excludesImages filter', () {
      const filter = TweetSearchFilter(
        excludesImages: true,
      );

      expect(filter.buildQuery(), equals('-filter:images'));
    });

    test('builds query with excludesVideo filter', () {
      const filter = TweetSearchFilter(
        excludesVideo: true,
      );

      expect(filter.buildQuery(), equals('-filter:native_video'));
    });

    test('builds query with excludesImages & excludesVideo filter', () {
      const filter = TweetSearchFilter(
        excludesImages: true,
        excludesVideo: true,
      );

      expect(filter.buildQuery(), equals('-filter:media'));
    });
  });
}
