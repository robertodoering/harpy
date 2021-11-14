import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/likes_retweets_screen.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class RetweetsScreen extends StatelessWidget {
  const RetweetsScreen({
    required this.tweetId,
    this.sort,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String tweetId;

  /// The [sort] of the how to order the users displayed
  final String? sort;

  static const String route = 'retweets';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RetweetsCubit>(
      create: (_) => RetweetsCubit()..loadRetweetedByUsers(tweetId),
      child: const HarpyScaffold(
        body: LikesRetweetsScreen(title: 'Retweeted By'),
      ),
    );
  }
}
