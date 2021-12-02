import 'package:harpy/core/core.dart';

class ListSortPreferences {
  const ListSortPreferences();

  /// The json encoded string for the list sort order.
  String get listSortOrder =>
      app<HarpyPreferences>().getString('listSortOrder', '', prefix: true);

  set listSortOrder(String value) =>
      app<HarpyPreferences>().setString('listSortOrder', value, prefix: true);
}
