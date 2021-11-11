part of 'retweets_bloc.dart';

class LoadRetweets extends LoadUsers {
  const LoadRetweets();

  @override
  Future<List<UserData?>> requestUsers(LikesRetweetsBloc bloc) async {
    final tweetId = bloc.tweetId;
    //TODO create some sort of function that manipulates the sorting based on the sort tyoe
    final sort = bloc.sort;

    if (tweetId != null) {
      final tweets = await app<TwitterApi>()
          .tweetService
          .retweets(id: tweetId, count: 100)
          .handleError(twitterApiErrorHandler);
      final users =
          tweets?.map((tweet) => UserData.fromUser(tweet.user)).toList() ?? [];

      return sortedUsers(sort, users);
    }
    return [];
  }

  List<UserData> sortedUsers(String? sort, List<UserData> users) {
    switch (sort) {
      case 'mostFollowers':
        {
          return users
            ..sort((a, b) => b.followersCount.compareTo(a.followersCount));
        }
      case 'leastFollowers':
        {
          return users
            ..sort((a, b) => a.followersCount.compareTo(b.followersCount));
        }
      case 'mostFollowing':
        {
          return users
            ..sort((a, b) => b.friendsCount.compareTo(a.friendsCount));
        }
      case 'leastFollowing':
        {
          return users
            ..sort((a, b) => a.friendsCount.compareTo(b.friendsCount));
        }
      case 'ASCDisplayName':
        {
          return users..sort((a, b) => a.name.compareTo(b.name));
        }
      case 'DSCDisplayName':
        {
          return users..sort((a, b) => b.name.compareTo(a.name));
        }
      default:
        {
          return users;
        }
    }
  }
}
