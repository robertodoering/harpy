import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'likes_cubit.freezed.dart';

class LikesCubit extends Cubit<PaginatedState<LikedByUsersData>>
    with RequestLock, HarpyLogger {
  LikesCubit() : super(const PaginatedState.loading());

  Future<void> _request({required String tweetId}) async {
    //TODO switch to api v2 to enable like lookup on tweets
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
          LikedByUsersData(tweetId: tweetId, users: users.toBuiltList());
      emit(
        PaginatedState.data(
          data: data,
        ),
      );
    }
  }

  Future<void> loadLikedByUsers(String tweetId) async {
    emit(const PaginatedState.loading());

    await _request(
      tweetId: tweetId,
    );
  }
}

@freezed
class LikedByUsersData with _$LikedByUsersData {
  const factory LikedByUsersData({
    required BuiltList<UserData> users,
    required String tweetId,
  }) = _Data;
}
