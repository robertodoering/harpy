import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class RetweetersCubit extends Cubit<PaginatedState<BuiltList<UserData>>>
    with RequestLock, HarpyLogger {
  RetweetersCubit({
    required this.tweetId,
  }) : super(const PaginatedState.loading());

  final String tweetId;

  Future<void> _request({bool clearPrevious = false}) async {
    if (clearPrevious) {
      emit(const PaginatedState.loading());
    }

    final users = await app<TwitterApi>()
        .tweetService
        .retweets(id: tweetId, count: 100)
        .then((tweets) => tweets.map((tweet) => UserData.fromUser(tweet.user)))
        .handleError(twitterApiErrorHandler);

    if (users != null) {
      if (users.isNotEmpty) {
        emit(PaginatedState.data(data: users.toBuiltList()));
      } else {
        emit(const PaginatedState.noData());
      }
    } else {
      emit(const PaginatedState.error());
    }
  }

  Future<void> loadRetweetedByUsers() async {
    emit(const PaginatedState.loading());

    await _request();
  }
}

List<UserData> createUsers(
  List<Tweet>? tweets,
) {
  return tweets?.map((tweet) => UserData.fromUser(tweet.user)).toList() ?? [];
}
