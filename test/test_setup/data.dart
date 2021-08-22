import 'package:harpy/api/api.dart';

const harpyAppUser = UserData(
  name: 'Harpy',
  handle: 'harpy_app',
  profileImageUrl: 'test/images/harpy_avatar.png',
);

final exampleTweet = TweetData(
  createdAt: DateTime(2021, 07, 29),
  user: harpyAppUser,
  images: [
    ImageData.fromImageUrl('test/images/red.png', 1),
  ],
);

final exampleTweetList = [
  exampleTweet,
];
