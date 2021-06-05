import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class PreviewTweetCard extends StatelessWidget {
  const PreviewTweetCard();

  @override
  Widget build(BuildContext context) {
    const text = '''
Thank you for using Harpy!

Make sure to follow @harpy_app for news and updates about the app.''';

    final tweet = TweetData(
      user: const UserData(
        name: 'Harpy',
        handle: 'harpy_app',
        profileImageUrl:
            'https://pbs.twimg.com/profile_images/1356691241140957190/'
            'N03_GPid_400x400.jpg',
      ),
      text: text,
      visibleText: text,
      entities: const EntitiesData(userMentions: [
        UserMentionData(handle: 'harpy_app'),
      ]),
      createdAt: DateTime.now(),
    );

    return TweetCard(
      tweet,
      create: (_) => PreviewTweetBloc(tweet),
    );
  }
}
