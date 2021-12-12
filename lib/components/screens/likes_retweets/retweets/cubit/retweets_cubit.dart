import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/user_sort_by_model.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/preferences/user_list_sort_preferences.dart';
import 'package:provider/provider.dart';

part 'retweets_cubit.freezed.dart';

class RetweetsCubit extends Cubit<PaginatedState<RetweetedUsersData>>
    with RequestLock, HarpyLogger {
  RetweetsCubit({required this.tweetId})
      : super(const PaginatedState.loading());
  late String tweetId;
  UserSortBy sort = UserSortBy.fromJsonString(
    app<UserListSortPreferences>().listSortOrder,
  );

  Future<void> _request() async {
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

  void persistSort(String encodedSort) {
    app<UserListSortPreferences>().listSortOrder = encodedSort;
  }

  void applySort(BuildContext context, String tweetId) {
    final sortBy = context.read<UserListSortByModel>();
    log.fine('set user list sort order');

    try {
      final encodedSort = jsonEncode(sortBy.value.toJson());
      log.finer('saving sort: $encodedSort');

      persistSort(encodedSort);
    } catch (e, st) {
      log.warning('unable to encode list sort order', e, st);
    }

    final currentState = state.data?.users.toList();
    final sortUsers = createUsers(null, sortBy.value, currentState);
    if (sortUsers.isNotEmpty) {
      final data = RetweetedUsersData(
        tweetId: tweetId,
        users: sortUsers.toBuiltList(),
      );
      emit(
        PaginatedState.data(
          data: data,
        ),
      );
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
      users.sort((a, b) => b.handle.compareTo(a.handle));
    } else if (sortBy.displayName) {
      users.sort((a, b) => b.name.compareTo(a.name));
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
