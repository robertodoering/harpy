import 'package:flutter/material.dart';
import 'package:harpy/components/screens/likes_retweets/common/likes_retweets_screen.dart';
import 'package:harpy/components/screens/likes_retweets/likes/bloc/likes_bloc.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class LikesScreen extends StatelessWidget {
  const LikesScreen({
    required this.tweetId,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String? tweetId;

  static const String route = 'likes';

  @override
  Widget build(BuildContext context) {
    return LikesRetweetsScreen<LikesBloc>(
      create: (_) => LikesBloc(tweetId: tweetId),
      userId: tweetId,
      title: 'Liked by',
      errorMessage: 'error loading likes',
      loadUsers: (bloc) => bloc.add(const LoadLikes()),
    );
  }
}
