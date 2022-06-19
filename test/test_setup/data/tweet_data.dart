import 'package:built_collection/built_collection.dart';
import 'package:harpy/api/api.dart';

import 'user_data.dart';

final exampleTweet = TweetData(
  createdAt: DateTime(2021, 07, 29),
  user: harpyAppUser,
  media: [
    ImageMediaData(
      baseUrl: 'test/images/red.png',
      aspectRatioDouble: 1,
    ),
  ],
);

final exampleTweetList = BuiltList.of([exampleTweet]);
