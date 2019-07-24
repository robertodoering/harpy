import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/media_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/compose_tweet_model.dart';
import 'package:mockito/mockito.dart';

class MockFile extends Mock implements File {}

class MockTweetService extends Mock implements TweetService {}

class MockMediaService extends Mock implements MediaService {}

void main() {
  setUp(() {
    app
      ..registerLazySingleton<TweetService>(() => MockTweetService())
      ..registerLazySingleton<MediaService>(() => MockMediaService());
  });

  tearDown(app.reset);

  test("Can add up to four images", () {
    final model = ComposeTweetModel();

    final File imageOne = MockFile();
    final File imageTwo = MockFile();
    final File imageThree = MockFile();
    final File imageFour = MockFile();
    final File imageFive = MockFile();

    when(imageOne.path).thenReturn("/path/to/my/imageOne.png");
    when(imageTwo.path).thenReturn("/path/to/my/imageTwo.jpg");
    when(imageThree.path).thenReturn("/path/to/my/imageThree.jpeg");
    when(imageFour.path).thenReturn("/path/to/my/imageFour.webp");
    when(imageFive.path).thenReturn("/path/to/my/imageFive.png");

    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(imageOne), true);
    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(imageTwo), true);
    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(imageThree), true);
    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(imageFour), true);
    expect(model.canAddMedia, false);
    expect(model.addMediaFileToList(imageFive), false);
  });

  test("Can add only one video", () {
    final model = ComposeTweetModel();

    final File videoOne = MockFile();
    final File videoTwo = MockFile();
    final File image = MockFile();

    when(videoOne.path).thenReturn("/path/to/my/videoOne.mp4");
    when(videoTwo.path).thenReturn("/path/to/my/videoTwo.mp4");
    when(image.path).thenReturn("/path/to/my/image.jpeg");

    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(videoOne), true);
    expect(model.canAddMedia, false);
    expect(model.addMediaFileToList(videoTwo), false);
    expect(model.addMediaFileToList(image), false);
  });

  test("Can add only one gif", () {
    final model = ComposeTweetModel();

    final File gifOne = MockFile();
    final File gifTwo = MockFile();
    final File image = MockFile();

    when(gifOne.path).thenReturn("/path/to/my/gifOne.gif");
    when(gifTwo.path).thenReturn("/path/to/my/gifTwo.gif");
    when(image.path).thenReturn("/path/to/my/image.jpeg");

    expect(model.canAddMedia, true);
    expect(model.addMediaFileToList(gifOne), true);
    expect(model.canAddMedia, false);
    expect(model.addMediaFileToList(gifTwo), false);
    expect(model.addMediaFileToList(image), false);
  });

  test("File extension gets validated", () {
    final model = ComposeTweetModel();

    final File unsupportedType = MockFile();
    final File noExtension = MockFile();
    final File validImage = MockFile();

    when(unsupportedType.path).thenReturn("/path/to/my/no_u.pdf");
    when(noExtension.path).thenReturn("/path/to/my/whatami");
    when(validImage.path).thenReturn("/path/to/my/sendnudes.jpeg");

    expect(model.addMediaFileToList(unsupportedType), false);
    expect(model.addMediaFileToList(noExtension), false);
    expect(model.addMediaFileToList(validImage), true);
  });

  test("Media file gets removed", () {
    final model = ComposeTweetModel();

    final File imageOne = MockFile();
    final File imageTwo = MockFile();

    when(imageOne.path).thenReturn("/path/to/my/imageOne.png");
    when(imageTwo.path).thenReturn("/path/to/my/imageTwo.jpg");

    expect(model.addMediaFileToList(imageOne), true);
    expect(model.addMediaFileToList(imageTwo), true);

    expect(model.media.length, 2);

    model.removeMedia(1);

    expect(model.media.length, 1);

    model.removeMedia(0);

    expect(model.media.length, 0);
  });

  test("Remove media with invalid index fails gracefully", () {
    final model = ComposeTweetModel();

    final File imageOne = MockFile();
    final File imageTwo = MockFile();

    when(imageOne.path).thenReturn("/path/to/my/imageOne.png");
    when(imageTwo.path).thenReturn("/path/to/my/imageTwo.jpg");

    expect(model.addMediaFileToList(imageOne), true);
    expect(model.addMediaFileToList(imageTwo), true);

    expect(model.media.length, 2);

    model.removeMedia(2);

    expect(model.media.length, 2);
  });

  test("Tweeting with media clears media list when successful", () async {
    final model = ComposeTweetModel();

    final File imageOne = MockFile();

    when(imageOne.path).thenReturn("/path/to/my/imageOne.png");

    when(app<MediaService>().upload(imageOne))
        .thenAnswer((_) => Future<String>.value("1337"));

    expect(model.addMediaFileToList(imageOne), true);

    expect(model.media.isEmpty, false);

    when(app<TweetService>().updateStatus(text: "text", mediaIds: ["1337"]))
        .thenAnswer((_) => Future<Tweet>.value(Tweet()));

    await model.tweet("text");

    expect(model.media.isEmpty, true);
  });

  test("Tweeting with invalid media adds the media to a _badMedia list",
      () async {
    final model = ComposeTweetModel();

    final File imageOne = MockFile();
    final File invalidImage = MockFile();

    when(imageOne.path).thenReturn("/path/to/my/imageOne.png");
    when(invalidImage.path).thenReturn("/path/to/my/no_u.png");

    when(app<MediaService>().upload(imageOne))
        .thenAnswer((_) => Future<String>.value("1337"));

    when(app<MediaService>().upload(invalidImage))
        .thenAnswer((_) => Future<String>.value(null));

    expect(model.addMediaFileToList(imageOne), true);
    expect(model.addMediaFileToList(invalidImage), true);

    await model.tweet("text");

    verifyNever(app<TweetService>()
        .updateStatus(text: anyNamed("text"), mediaIds: anyNamed("mediaIds")));

    expect(model.isBadFile(invalidImage), true);
    expect(model.isBadFile(imageOne), false);
  });
}
