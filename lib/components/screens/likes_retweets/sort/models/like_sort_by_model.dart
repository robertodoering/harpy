import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/preferences/user_list_sort_preferences.dart';

// TODO: refactor into cubit

class UserListSortByModel extends ValueNotifier<ListSortBy> {
  UserListSortByModel.sort() : super(ListSortBy.empty) {
    value = ListSortBy.fromJsonString(
      app<UserListSortPreferences>().listSortOrder,
    );
  }

  bool get hasSort => value != TimelineFilter.empty;

  void clear() {
    value = ListSortBy.empty;
  }

  void setByHandle(bool byHandle) {
    value = value.copyWith(
        byHandle: byHandle,
        byDisplayName: false,
        byFollowers: false,
        byFollowing: false);
  }

  void setByDisplayName(bool byDisplayName) {
    value = value.copyWith(
        byDisplayName: byDisplayName,
        byHandle: false,
        byFollowers: false,
        byFollowing: false);
  }

  void setByFollowers(bool byFollowers) {
    value = value.copyWith(
      byFollowers: byFollowers,
      byFollowing: false,
      byDisplayName: false,
      byHandle: false,
    );
  }

  void setByFollowing(bool byFollowing) {
    value = value.copyWith(
      byFollowing: byFollowing,
      byFollowers: false,
      byDisplayName: false,
      byHandle: false,
    );
  }
}
