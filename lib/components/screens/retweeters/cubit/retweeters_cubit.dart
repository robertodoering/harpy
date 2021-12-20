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
  }) : super(const PaginatedState.loading()) {
    _request();
  }

  final String tweetId;

  Future<void> _request() async {
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
}
