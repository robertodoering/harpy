import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

import '../../test_setup/data/user_data.dart';
import '../../test_setup/setup.dart';

void main() {
  setUpAll(loadAppFonts);

  group('tweet card', () {
    testGoldens('builds minimal tweet card with top & actions row',
        (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy,
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'minimal_tweet_card');

      expect(find.byType(TweetCardTopRow), findsOneWidget);
      expect(find.byType(TweetCardActions), findsOneWidget);
    });

    testGoldens('builds top row with long name', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy.copyWith(
              name: 'Harpy with a really long name, like, really long.',
              handle: 'harpy_app_userhandle_size_is_normally_limited',
            ),
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'top_row_long');

      expect(find.byType(TweetCardTopRow), findsOneWidget);
    });

    testGoldens('builds top row with empty name and handle', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy.copyWith(
              name: '',
              handle: '',
            ),
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'top_row_empty_name');

      expect(find.byType(TweetCardTopRow), findsOneWidget);
    });

    testGoldens('builds top row with zero width name', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy.copyWith(
              name: '\u064E',
              handle: '',
            ),
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'top_row_zero_width_name');

      expect(find.byType(TweetCardTopRow), findsOneWidget);
    });

    testGoldens('builds text', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            user: userDataHarpy,
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'text');

      expect(find.byType(TweetCardText), findsOneWidget);
    });

    testGoldens('builds translation button when text is translatable',
        (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            user: userDataHarpy,
          ),
        ),
        wrapper: (child) => buildListItemBase(
          child,
          preferences: {'translateLanguage': 'de'},
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'text_translatable');

      expect(find.byType(TweetCardTranslation), findsOneWidget);
      expect(find.byType(TranslateButton), findsOneWidget);
    });

    testGoldens('builds translation', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            translation: Translation(
              text: 'Hallo Welt!',
              language: 'German',
              languageCode: 'de',
              original: 'en',
            ),
            user: userDataHarpy,
          ),
        ),
        wrapper: (child) => buildListItemBase(
          child,
          preferences: {'translateLanguage': 'de'},
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'translation');

      expect(find.byType(TweetCardTranslation), findsOneWidget);
      expect(find.text('Hallo Welt!'), findsOneWidget);
    });

    testGoldens("builds no translation when translation didn't change",
        (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            translation: Translation(
              language: '',
              languageCode: '',
              original: '',
              text: '',
            ),
            user: userDataHarpy,
          ),
        ),
        wrapper: (child) => buildListItemBase(
          child,
          preferences: {'translateLanguage': 'de'},
        ),
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'translation_empty');

      expect(find.byType(TranslatedText), findsNothing);
      expect(find.byType(TranslateButton), findsOneWidget);
    });

    testGoldens('builds media with 1 image', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy,
            media: [
              ImageMediaData(
                baseUrl: 'yellow.png',
                aspectRatioDouble: 16 / 9,
              ),
            ],
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_one_image');

      expect(find.byType(TweetCardMedia), findsOneWidget);
      expect(find.byType(TweetImages), findsOneWidget);
      // avatar + 1 media image
      expect(find.byType(HarpyImage), findsNWidgets(2));
    });

    testGoldens('builds media with 4 images', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy,
            media: [
              ImageMediaData(
                baseUrl: 'red.png',
                aspectRatioDouble: 16 / 9,
              ),
              ImageMediaData(
                baseUrl: 'magenta.png',
                aspectRatioDouble: 16 / 9,
              ),
              ImageMediaData(
                baseUrl: 'blue.png',
                aspectRatioDouble: 16 / 9,
              ),
              ImageMediaData(
                baseUrl: 'aqua.png',
                aspectRatioDouble: 16 / 9,
              ),
            ],
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_four_images');

      expect(find.byType(TweetCardMedia), findsOneWidget);
      expect(find.byType(TweetImages), findsOneWidget);
      // avatar + 4 media images
      expect(find.byType(HarpyImage), findsNWidgets(5));
    });

    testGoldens('builds media with video', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy,
            media: [
              VideoMediaData.fromV1(
                Media()
                  ..type = kMediaVideo
                  ..videoInfo = (VideoInfo()
                    ..aspectRatio = [16, 9]
                    ..durationMillis = 817000
                    ..variants = [
                      Variant()
                        ..bitrate = 1
                        ..url = 'red.png',
                    ])
                  ..mediaUrlHttps = 'red.png',
              ),
            ],
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_video');

      expect(find.byType(TweetCardMedia), findsOneWidget);
      expect(find.byType(TweetVideo), findsOneWidget);
      expect(find.byType(TweetVideo), findsOneWidget);
    });

    testGoldens('builds media with gif', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            createdAt: DateTime.now(),
            user: userDataHarpy,
            media: [
              VideoMediaData.fromV1(
                Media()
                  ..type = kMediaGif
                  ..videoInfo = (VideoInfo()
                    ..aspectRatio = [16, 9]
                    ..variants = [])
                  ..mediaUrlHttps = 'blue.png',
              ),
            ],
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_gif');

      expect(find.byType(TweetCardMedia), findsOneWidget);
      expect(find.byType(TweetGif), findsOneWidget);
    });

    testGoldens('builds quote', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          tweet: LegacyTweetData(
            originalId: '1',
            createdAt: DateTime.now(),
            user: userDataHarpy,
            text: 'text',
            visibleText: 'text',
            quote: LegacyTweetData(
              originalId: '2',
              createdAt: DateTime.now(),
              user: userDataHarpy,
              text: 'quote text',
              visibleText: 'quote text',
            ),
          ),
        ),
        wrapper: buildListItemBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'quote');

      expect(find.text('quote text', findRichText: true), findsOneWidget);
    });
  });
}
