import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/api/helper/network_error_handler.dart';
import 'package:harpy/api/twitter/data/user_data.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'retweets_cubit.freezed.dart';

class RetweetsCubit extends Cubit<PaginatedState<RetweetedUsersData>>
    with RequestLock, HarpyLogger {
  RetweetsCubit() : super(const PaginatedState.loading());

  Future<void> _request({required String tweetId}) async {
    final users = await app<TwitterApi>()
        .tweetService
        .retweets(id: tweetId, count: 100)
        .handleError(twitterApiErrorHandler)
        .then(
          (tweets) =>
              tweets?.map((tweet) => UserData.fromUser(tweet.user)).toList(),
        );
    if (users != null) {
      // assume last page requested
      final data =
          RetweetedUsersData(tweetId: tweetId, users: users.toBuiltList());
      emit(
        PaginatedState.data(
          data: data,
        ),
      );
    }
  }

  Future<void> loadRetweetedByUsers(String tweetId) async {
    emit(const PaginatedState.loading());

    await _request(
      tweetId: tweetId,
    );
  }
}

@freezed
class RetweetedUsersData with _$RetweetedUsersData {
  const factory RetweetedUsersData({
    required BuiltList<UserData> users,
    required String tweetId,
  }) = _Data;
}
