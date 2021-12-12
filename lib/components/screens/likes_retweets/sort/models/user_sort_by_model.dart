import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/preferences/user_list_sort_preferences.dart';

// TODO: refactor into cubit

class UserListSortByModel extends ValueNotifier<UserSortBy> {
  UserListSortByModel.sort() : super(UserSortBy.empty) {
    value = UserSortBy.fromJsonString(
      app<UserListSortPreferences>().listSortOrder,
    );
  }

  bool get hasSort => value != TimelineFilter.empty;

  void clear() {
    value = UserSortBy.empty;
  }

  void setByHandle(bool handle) {
    value = value.copyWith(
      handle: handle,
      displayName: false,
      followers: false,
      following: false,
    );
  }

  void setByDisplayName(bool displayName) {
    value = value.copyWith(
      displayName: displayName,
      handle: false,
      followers: false,
      following: false,
    );
  }

  void setByFollowers(bool followers) {
    value = value.copyWith(
      followers: followers,
      following: false,
      displayName: false,
      handle: false,
    );
  }

  void setByFollowing(bool following) {
    value = value.copyWith(
      following: following,
      followers: false,
      displayName: false,
      handle: false,
    );
  }
}
