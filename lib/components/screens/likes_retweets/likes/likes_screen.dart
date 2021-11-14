import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/likes/cubit/likes_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/likes_retweets_screen.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class LikesScreen extends StatelessWidget {
  const LikesScreen({
    required this.tweetId,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String tweetId;

  static const String route = 'likes';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikesCubit>(
      create: (_) => LikesCubit()..loadLikedByUsers(tweetId),
      child: const HarpyScaffold(
        body: LikesRetweetsScreen(title: 'Liked By'),
      ),
    );
  }
}
