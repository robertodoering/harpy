import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class PreviewTweetCard extends StatelessWidget {
  const PreviewTweetCard();

  static final previewTweet = TweetData.fromTweet(
    Tweet()
      ..idStr = '-1'
      ..fullText = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, '
          'sed diam nonumy eirmod tempor invidunt ut labore '
          'et dolore magna aliquyam erat, sed diam voluptua. '
          'At vero eos et accusam et justo duo dolores et ea '
          'rebum. Stet clita kasd gubergren, no sea takimata '
          'sanctus est Lorem ipsum dolor sit amet.'
      ..user = (User()
        ..name = 'Harpy'
        ..screenName = 'harpy_app'
        ..profileImageUrlHttps =
            'https://pbs.twimg.com/profile_images/1356691241140957190'
                '/N03_GPid_400x400.jpg'),
  );

  @override
  Widget build(BuildContext context) {
    return TweetCard(
      previewTweet,
      create: (_) => PreviewTweetBloc(previewTweet),
    );
  }
}
