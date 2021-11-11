import 'package:flutter/material.dart';
import 'package:harpy/components/screens/likes_retweets/common/likes_retweets_screen.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/bloc/retweets_bloc.dart';

/// Builds the screen with a list of the followers for the user with the
/// [tweetId].
class RetweetsScreen extends StatelessWidget {
  const RetweetsScreen({
    required this.tweetId,
    this.sort,
  });

  /// The [tweetId] of the user whom to search the followers for.
  final String? tweetId;

  /// The [sort] of the how to order the users displayed
  final String? sort;

  static const String route = 'retweets';

  @override
  Widget build(BuildContext context) {
    return LikesRetweetsScreen<RetweetsBloc>(
      create: (_) => RetweetsBloc(tweetId: tweetId, sort: sort),
      userId: tweetId,
      title: 'Retweeted by',
      errorMessage: 'error loading retweets',
      loadUsers: (bloc) => bloc.add(const LoadRetweets()),
    );
  }
}
