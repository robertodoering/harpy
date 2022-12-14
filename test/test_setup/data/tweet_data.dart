import 'package:built_collection/built_collection.dart';
import 'package:harpy/api/api.dart';

import 'user_data.dart';

final exampleTweet = LegacyTweetData(
  createdAt: DateTime(2021, 07, 29),
  user: userDataHarpy,
  media: [
    ImageMediaData(
      baseUrl: 'red.png',
      aspectRatioDouble: 1,
    ),
  ],
);

final exampleTweetList = BuiltList.of([exampleTweet]);
