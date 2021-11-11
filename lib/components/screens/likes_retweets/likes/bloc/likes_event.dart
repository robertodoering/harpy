part of 'likes_bloc.dart';

class LoadLikes extends LoadUsers {
  const LoadLikes();

  @override
  Future<List<UserData?>> requestUsers(LikesRetweetsBloc bloc) async {
    final tweetId = bloc.tweetId;
    if (tweetId != null) {
      final tweets = await app<TwitterApi>()
          .tweetService
          .retweets(id: tweetId, count: 100)
          .handleError(twitterApiErrorHandler);
      final users =
          tweets?.map((tweet) => UserData.fromUser(tweet.user)).toList() ?? [];
      return users;
    }
    return [];
  }
}
