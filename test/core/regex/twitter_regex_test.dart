// ignore_for_file: unused_result

import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/core.dart';

void main() {
  group('hashtag regex', () {
    test('matches hashtags', () {
      expect(hashtagRegex.hasMatch('#hashtag'), isTrue);
      expect(hashtagRegex.hasMatch('bad#hashtag'), isFalse);
      expect(hashtagRegex.hasMatch('#hag\u0303ua'), isTrue);
      expect(hashtagRegex.hasMatch('#\u05e2\u05d1\u05e8\u05d9\u05ea'), isTrue);
      expect(
        hashtagRegex.hasMatch('#\u05d0\u05b2\u05e9\u05b6\u05c1\u05e8'),
        isTrue,
      );
      expect(
        hashtagRegex.hasMatch('#\u0627\u0644\u0639\u0631\u0628\u064a\u0629'),
        isTrue,
      );
      expect(hashtagRegex.hasMatch('#ประเทศไทย'), isTrue);
      expect(hashtagRegex.hasMatch('#ฟรี'), isTrue);
      expect(hashtagRegex.hasMatch('#日本語ハッシュタグ'), isTrue);
      expect(hashtagRegex.hasMatch('＃日本語ハッシュタグ'), isTrue);
      expect(hashtagRegex.hasMatch('これはOK #ハッシュタグ'), isTrue);
      expect(hashtagRegex.hasMatch('これもOK。#ハッシュタグ'), isTrue);
      expect(hashtagRegex.hasMatch('これはダメ#ハッシュタグ'), isFalse);
      expect(hashtagRegex.hasMatch('_#hashtage'), isTrue);
      expect(hashtagRegex.hasMatch(' #hashtag'), isTrue);
      expect(hashtagRegex.hasMatch('(#hashtag)'), isTrue);

      expect(hashtagRegex.hasMatch('#'), isFalse);
      expect(hashtagRegex.hasMatch('.#'), isFalse);
      expect(hashtagRegex.hasMatch('＃'), isFalse);
    });
  });

  group('hashtag start regex', () {
    test('matches the start of a hashtag', () {
      expect(hashtagStartRegex.hasMatch('#'), isTrue);
      expect(hashtagStartRegex.hasMatch('no#'), isFalse);
      expect(hashtagStartRegex.hasMatch('.#'), isTrue);
      expect(hashtagStartRegex.hasMatch('＃'), isTrue);
      expect(hashtagStartRegex.hasMatch('#hashtag'), isTrue);
    });
  });

  group('mention regex', () {
    test('matches mentions', () {
      expect(mentionRegex.hasMatch('@username'), isTrue);
      expect(mentionRegex.hasMatch('@123'), isTrue);
      expect(mentionRegex.hasMatch('@user_name123'), isTrue);
      expect(mentionRegex.hasMatch('bad@username'), isFalse);
      expect(mentionRegex.hasMatch('。@username'), isTrue);
      expect(mentionRegex.hasMatch('_@username'), isTrue);
      expect(mentionRegex.hasMatch(' @username'), isTrue);
      expect(mentionRegex.hasMatch('(@username)'), isTrue);
      expect(mentionRegex.hasMatch('これはOK @username'), isTrue);
      expect(mentionRegex.hasMatch('これもOK。@username'), isTrue);
      expect(mentionRegex.hasMatch('これはダメ@username'), isFalse);

      expect(mentionRegex.hasMatch('@'), isFalse);
      expect(mentionRegex.hasMatch('.@'), isFalse);
      expect(mentionRegex.hasMatch('。@'), isFalse);
    });
  });

  group('mention start regex', () {
    test('matches the start of a mention', () {
      expect(mentionStartRegex.hasMatch('@'), isTrue);
      expect(mentionStartRegex.hasMatch('no@'), isFalse);
      expect(mentionStartRegex.hasMatch('.@'), isTrue);
      expect(mentionStartRegex.hasMatch('。@'), isTrue);
      expect(mentionStartRegex.hasMatch('@'), isTrue);
      expect(mentionStartRegex.hasMatch('@username'), isTrue);
    });
  });

  group('twitter path regex', () {
    test('user profile', () {
      expect(
        userProfilePathRegex.firstMatch('/harpy_app'),
        isA<RegExpMatch>().having(
          (match) => match.group(1),
          'user handle',
          equals('harpy_app'),
        ),
      );
      expect(userProfilePathRegex.hasMatch('harpy_app'), isFalse);
      expect(userProfilePathRegex.hasMatch('/harpy_app/'), isFalse);
      expect(userProfilePathRegex.hasMatch('/harpy_app/asdf'), isFalse);
    });

    test('user followers', () {
      expect(
        userFollowersPathRegex.firstMatch('/harpy_app/followers'),
        isA<RegExpMatch>().having(
          (match) => match.group(1),
          'user handle',
          equals('harpy_app'),
        ),
      );
      expect(userFollowersPathRegex.hasMatch('/harpy_app'), isFalse);
      expect(
        userFollowersPathRegex.hasMatch('/harpy_app/followers/asdf'),
        isFalse,
      );
    });

    test('user following', () {
      expect(
        userFollowingPathRegex.firstMatch('/harpy_app/following'),
        isA<RegExpMatch>().having(
          (match) => match.group(1),
          'user handle',
          equals('harpy_app'),
        ),
      );
      expect(userFollowingPathRegex.hasMatch('/harpy_app'), isFalse);
      expect(
        userFollowingPathRegex.hasMatch('/harpy_app/following/asdf'),
        isFalse,
      );
    });

    test('user lists', () {
      expect(
        userListsPathRegex.firstMatch('/harpy_app/lists'),
        isA<RegExpMatch>().having(
          (match) => match.group(1),
          'user handle',
          equals('harpy_app'),
        ),
      );
      expect(userListsPathRegex.hasMatch('/harpy_app'), isFalse);
      expect(userListsPathRegex.hasMatch('/harpy_app/lists/asdf'), isFalse);
    });

    test('status', () {
      expect(
        statusPathRegex.firstMatch('/harpy_app/status/1463545080837509120'),
        isA<RegExpMatch>()
          ..having(
            (match) => match.group(1),
            'user handle',
            equals('harpy_app'),
          )
          ..having(
            (match) => match.group(2),
            'status id',
            equals('1463545080837509120'),
          ),
      );
      expect(
        statusPathRegex.hasMatch('/harpy_app/status/1463545080837509120/asdf'),
        isFalse,
      );
      expect(statusPathRegex.hasMatch('/harpy_app/status'), isFalse);
      expect(statusPathRegex.hasMatch('/harpy_app/status/asdf'), isFalse);
    });

    test('status retweets', () {
      expect(
        statusRetweetsPathRegex.firstMatch(
          '/harpy_app/status/1463545080837509120/retweets',
        ),
        isA<RegExpMatch>()
          ..having(
            (match) => match.group(1),
            'user handle',
            equals('harpy_app'),
          )
          ..having(
            (match) => match.group(2),
            'status id',
            equals('1463545080837509120'),
          ),
      );
      expect(
        statusRetweetsPathRegex.hasMatch(
          '/harpy_app/status/1463545080837509120/retweets/asdf',
        ),
        isFalse,
      );
      expect(
        statusRetweetsPathRegex.hasMatch(
          '/harpy_app/status/1463545080837509120',
        ),
        isFalse,
      );
      expect(
        statusRetweetsPathRegex.hasMatch('/harpy_app/status/asdf/retweets'),
        isFalse,
      );
    });
  });
}
