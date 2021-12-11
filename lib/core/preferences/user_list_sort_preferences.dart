import 'package:harpy/core/core.dart';

class UserListSortPreferences {
  const UserListSortPreferences();

  /// The json encoded string for the list sort order.
  String get listSortOrder =>
      app<HarpyPreferences>().getString('userListSortOrder', '', prefix: true);

  set listSortOrder(String value) =>
      app<HarpyPreferences>().setString('userListSortOrder', value, prefix: true);
}
