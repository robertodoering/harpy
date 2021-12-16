import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/retweeters/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/retweeters/retweets_screen.dart';

/// Builds the screen with a list of users that retweeted a tweet
/// [tweetId].
class RetweetersScreen extends StatelessWidget {
  const RetweetersScreen({
    required this.tweetId,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String tweetId;

  static const String route = 'retweets';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RetweetersCubit(tweetId: tweetId)..loadRetweetedByUsers(),
      child: const HarpyScaffold(
        body: RetweetsScreen(title: 'Retweeted By'),
      ),
    );
  }
}
