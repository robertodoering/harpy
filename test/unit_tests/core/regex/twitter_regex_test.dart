import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/regex/twitter_regex.dart';

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
}
