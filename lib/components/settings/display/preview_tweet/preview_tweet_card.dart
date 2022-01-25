import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class PreviewTweetCard extends StatelessWidget {
  const PreviewTweetCard({
    this.text = '''
Thank you for using harpy!

Make sure to follow @harpy_app for news and updates about the app''',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final tweet = TweetData(
      user: const UserData(
        name: 'harpy',
        handle: 'harpy_app',
        id: '1068105113284300800',
        profileImageUrl: 'https://pbs.twimg.com/profile_images/'
            '1356691241140957190/N03_GPid_400x400.jpg',
      ),
      text: text,
      visibleText: text,
      entities: const EntitiesData(
        userMentions: [
          UserMentionData(handle: 'harpy_app'),
        ],
      ),
      createdAt: DateTime.now(),
    );

    return BlocProvider<TweetBloc>(
      create: (_) => PreviewTweetBloc(tweet, enableUserTap: true),
      child: const TweetCardBase(),
    );
  }
}
