import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'retweets_cubit.freezed.dart';

class RetweetsCubit extends Cubit<PaginatedState<RetweetedUsersData>>
    with RequestLock, HarpyLogger {
  RetweetsCubit({
    required this.tweetId,
  }) : super(const PaginatedState.loading());

  final String tweetId;

  UserSortBy sort = UserSortBy.fromJsonString(
    app<UserListSortPreferences>().listSortOrder,
  );

  Future<void> _request({bool clearPrevious = false}) async {
    if (clearPrevious) {
      emit(const PaginatedState.loading());
    }

    final users = await app<TwitterApi>()
        .tweetService
        .retweets(id: tweetId, count: 100)
        .handleError(twitterApiErrorHandler)
        .then(
          (tweets) => createUsers(tweets, sort, null),
        );

    if (users.isNotEmpty) {
      final data = RetweetedUsersData(
        tweetId: tweetId,
        users: users.toBuiltList(),
      );
      emit(
        PaginatedState.data(
          data: data,
        ),
      );
    }
  }

  Future<void> loadRetweetedByUsers() async {
    emit(const PaginatedState.loading());

    await _request();
  }

  // following the correct rule but ide takes something else is happening
  // ignore: use_setters_to_change_properties
  void persistSort(String encodedSort) {
    app<UserListSortPreferences>().listSortOrder = encodedSort;
  }

  void applySort(UserSortBy userSort) {
    try {
      final encodedSort = jsonEncode(userSort.toJson());
      log.finer('saving sort: $encodedSort');

      persistSort(encodedSort);
    } catch (e, st) {
      log.warning('unable to encode list sort order', e, st);
    }

    final currentState = state.data?.users.toList();

    sort = userSort;
    if (userSort != UserSortBy.empty) {
      final data = RetweetedUsersData(
        tweetId: tweetId,
        users: createUsers(null, userSort, currentState).toBuiltList(),
      );
      emit(
        PaginatedState.data(
          data: data,
        ),
      );
    } else {
      _request(clearPrevious: true);
    }
  }
}

List<UserData> createUsers(
  List<Tweet>? tweets,
  UserSortBy? sortBy,
  List<UserData>? loadedUsers,
) {
  final users = loadedUsers ??
      (tweets?.map((tweet) => UserData.fromUser(tweet.user)).toList() ?? []);
  if (sortBy != null) {
    if (sortBy.handle) {
      users.sort((a, b) => a.handle.compareTo(b.handle));
    } else if (sortBy.displayName) {
      users.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy.followers) {
      users.sort((a, b) => b.followersCount.compareTo(a.followersCount));
    } else if (sortBy.following) {
      users.sort((a, b) => b.friendsCount.compareTo(a.friendsCount));
    }
  }
  return users;
}

@freezed
class RetweetedUsersData with _$RetweetedUsersData {
  const factory RetweetedUsersData({
    required BuiltList<UserData> users,
    required String tweetId,
  }) = _Data;
}
