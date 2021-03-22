import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';

void main() {
  group('tweet search filter', () {
    test('builds an empty query with an empty filter', () {
      const TweetSearchFilter filter = TweetSearchFilter();

      expect(filter.buildQuery(), equals(''));
    });

    test('builds query with tweet author filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        tweetAuthor: 'harpy_app',
      );

      expect(filter.buildQuery(), equals('from:harpy_app'));
    });

    test('builds query with replying to filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        replyingTo: 'harpy_app',
      );

      expect(filter.buildQuery(), equals('to:harpy_app'));
    });

    test('builds query with includesPhrases filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        includesPhrases: <String>['cat'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        includesPhrases: <String>['cute', 'cat'],
      );

      const TweetSearchFilter filter3 = TweetSearchFilter(
        includesPhrases: <String>['cute cat', 'petting'],
      );

      expect(filter1.buildQuery(), equals('cat'));
      expect(filter2.buildQuery(), equals('cute cat'));
      expect(filter3.buildQuery(), equals('"cute cat" petting'));
    });

    test('builds query with includesHashtags filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        includesHashtags: <String>['#cute'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        includesHashtags: <String>['#cute', '#cat'],
      );

      expect(filter1.buildQuery(), equals('#cute'));
      expect(filter2.buildQuery(), equals('#cute #cat'));
    });

    test('builds query with includesMentions filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        includesMentions: <String>['@harpy_app'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        includesHashtags: <String>['@harpy_app', '@NASA'],
      );

      expect(filter1.buildQuery(), equals('@harpy_app'));
      expect(filter2.buildQuery(), equals('@harpy_app @NASA'));
    });

    test('builds query with includesUrls filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        includesUrls: <String>['google'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        includesUrls: <String>['google', 'github'],
      );

      expect(filter1.buildQuery(), equals('url:google'));
      expect(filter2.buildQuery(), equals('url:google url:github'));
    });

    test('builds query with includesRetweets filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        includesRetweets: true,
      );

      expect(filter.buildQuery(), equals('filter:retweets'));
    });

    test('builds query with includesImages filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        includesImages: true,
      );

      expect(filter.buildQuery(), equals('filter:images'));
    });

    test('builds query with includesVideo filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        includesVideo: true,
      );

      expect(filter.buildQuery(), equals('filter:native_video'));
    });

    test('builds query with includesImages & includesVideo filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        includesImages: true,
        includesVideo: true,
      );

      expect(filter.buildQuery(), equals('filter:media'));
    });

    test('builds query with excludesPhrases filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        excludesPhrases: <String>['cat'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        excludesPhrases: <String>['cute', 'cat'],
      );

      const TweetSearchFilter filter3 = TweetSearchFilter(
        excludesPhrases: <String>['cute cat', 'petting'],
      );

      expect(filter1.buildQuery(), equals('-cat'));
      expect(filter2.buildQuery(), equals('-cute -cat'));
      expect(filter3.buildQuery(), equals('-"cute cat" -petting'));
    });

    test('builds query with excludesHashtags filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        excludesHashtags: <String>['-#cute'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        excludesHashtags: <String>['-#cute', '-#cat'],
      );

      expect(filter1.buildQuery(), equals('-#cute'));
      expect(filter2.buildQuery(), equals('-#cute -#cat'));
    });

    test('builds query with excludesMentions filter', () {
      const TweetSearchFilter filter1 = TweetSearchFilter(
        excludesMentions: <String>['-@harpy_app'],
      );

      const TweetSearchFilter filter2 = TweetSearchFilter(
        excludesMentions: <String>['-@harpy_app', '-@NASA'],
      );

      expect(filter1.buildQuery(), equals('-@harpy_app'));
      expect(filter2.buildQuery(), equals('-@harpy_app -@NASA'));
    });

    test('builds query with excludesRetweets filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        excludesRetweets: true,
      );

      expect(filter.buildQuery(), equals('-filter:retweets'));
    });

    test('builds query with excludesImages filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        excludesImages: true,
      );

      expect(filter.buildQuery(), equals('-filter:images'));
    });

    test('builds query with excludesVideo filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        excludesVideo: true,
      );

      expect(filter.buildQuery(), equals('-filter:native_video'));
    });

    test('builds query with excludesImages & excludesVideo filter', () {
      const TweetSearchFilter filter = TweetSearchFilter(
        excludesImages: true,
        excludesVideo: true,
      );

      expect(filter.buildQuery(), equals('-filter:media'));
    });
  });
}
