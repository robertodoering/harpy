import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

import '../../../../test_setup/data.dart';
import '../../../../test_setup/setup.dart';

void main() {
  setUpAll(loadAppFonts);

  setUp(setupApp);

  tearDown(app.reset);

  group('tweet card', () {
    testGoldens('builds minimal tweet card with top & actions row',
        (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'minimal_tweet_card');

      final topRow = find.byType(TweetCardTopRow);
      final actionsRow = find.byType(TweetCardActionsRow);

      expect(topRow, findsOneWidget);
      expect(actionsRow, findsOneWidget);
    });

    testGoldens('builds top row with long name', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser.copyWith(
              name: 'Harpy with a really long name, like, really long.',
              handle: 'harpy_app_userhandle_size_is_normally_limited',
            ),
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'top_row_long');

      final topRow = find.byType(TweetCardTopRow);

      expect(topRow, findsOneWidget);
    });

    testGoldens('builds text', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            user: harpyAppUser,
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'text');

      final text = find.byType(TweetCardText);

      expect(text, findsOneWidget);
    });

    testGoldens('builds translation button when text is translatable',
        (tester) async {
      app<LanguagePreferences>().translateLanguage = 'de';

      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            user: harpyAppUser,
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'text_translatable');

      final translation = find.byType(TweetCardTranslation);
      final translationButton = find.byType(TranslationButton);

      expect(translation, findsOneWidget);
      expect(translationButton, findsOneWidget);
    });

    testGoldens('builds translation', (tester) async {
      app<LanguagePreferences>().translateLanguage = 'de';

      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            translation: const Translation(
              text: 'Hallo Welt!',
              language: 'German',
            ),
            user: harpyAppUser,
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'translation');

      final translation = find.byType(TweetCardTranslation);
      final translationValue = find.text('Hallo Welt!');

      expect(translation, findsOneWidget);
      expect(translationValue, findsOneWidget);
    });

    testGoldens("builds no translation when translation didn't change",
        (tester) async {
      app<LanguagePreferences>().translateLanguage = 'de';

      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            text: 'Hello World!',
            visibleText: 'Hello World!',
            lang: 'en',
            translation: const Translation(),
            user: harpyAppUser,
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'translation_empty');
    });

    testGoldens('builds media with 1 image', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
            images: [
              ImageData.fromImageUrl('test/images/yellow.png', 16 / 9),
            ],
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_one_image');

      final media = find.byType(TweetMedia);
      final tweetImages = find.byType(TweetImages);
      final harpyImage = find.byType(HarpyImage);

      expect(media, findsOneWidget);
      expect(tweetImages, findsOneWidget);
      // avatar + 1 media image
      expect(harpyImage, findsNWidgets(2));
    });

    testGoldens('builds media with 4 images', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
            images: [
              ImageData.fromImageUrl('test/images/red.png', 16 / 9),
              ImageData.fromImageUrl('test/images/magenta.png', 16 / 9),
              ImageData.fromImageUrl('test/images/blue.png', 16 / 9),
              ImageData.fromImageUrl('test/images/aqua.png', 16 / 9),
            ],
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_four_images');

      final media = find.byType(TweetMedia);
      final tweetImages = find.byType(TweetImages);
      final harpyImage = find.byType(HarpyImage);

      expect(media, findsOneWidget);
      expect(tweetImages, findsOneWidget);
      // avatar + 4 media images
      expect(harpyImage, findsNWidgets(5));
    });

    testGoldens('builds media with video', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
            video: VideoData.fromMedia(
              Media()
                ..videoInfo = (VideoInfo()
                  ..aspectRatio = [16, 9]
                  ..variants = [])
                ..mediaUrlHttps = 'test/images/red.png',
            ),
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_video');

      final media = find.byType(TweetMedia);
      final tweetVideo = find.byType(TweetVideo);
      final videoPlayer = find.byType(HarpyVideoPlayer);

      expect(media, findsOneWidget);
      expect(tweetVideo, findsOneWidget);
      expect(videoPlayer, findsOneWidget);
    });

    testGoldens('builds media with gif', (tester) async {
      app<MediaPreferences>().autoplayMedia = 2;

      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
            gif: VideoData.fromMedia(
              Media()
                ..videoInfo = (VideoInfo()
                  ..aspectRatio = [16, 9]
                  ..variants = [])
                ..mediaUrlHttps = 'test/images/blue.png',
            ),
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'media_gif');

      final media = find.byType(TweetMedia);
      final tweetGif = find.byType(TweetGif);
      final gifPlayer = find.byType(HarpyGifPlayer);

      expect(media, findsOneWidget);
      expect(tweetGif, findsOneWidget);
      expect(gifPlayer, findsOneWidget);
    });

    testGoldens('builds quote', (tester) async {
      await tester.pumpWidgetBuilder(
        TweetCard(
          TweetData(
            createdAt: DateTime.now(),
            user: harpyAppUser,
            text: 'text',
            visibleText: 'text',
            quote: TweetData(
              createdAt: DateTime.now(),
              user: harpyAppUser,
              text: 'quote text',
              visibleText: 'quote text',
            ),
          ),
        ),
        wrapper: buildAppListBase,
        surfaceSize: Device.phone.size,
      );

      await screenMatchesGolden(tester, 'quote');

      final content = find.byType(TweetCardContent);

      expect(content, findsNWidgets(2));
    });
  });
}
