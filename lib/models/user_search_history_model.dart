import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/user_search/user_search_delegate.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:provider/provider.dart';

/// Provides methods for adding and retrieving user search queries to the
/// [HarpyPrefs].
///
/// Previously searched queries are displayed in the [UserSearchDelegate].
class UserSearchHistoryModel {
  final HarpyPrefs harpyPrefs = app<HarpyPrefs>();

  static MediaSettingsModel of(BuildContext context) {
    return Provider.of<MediaSettingsModel>(context);
  }

  /// Add the [query] to the previously searched queries.
  ///
  /// Only the newest 10 queries get saved.
  void addSearchQuery(String query) {
    final List<String> history = searchHistory();

    if (history.contains(query)) {
      history.remove(query);
    }

    history.insert(0, query);

    harpyPrefs.preferences.setStringList(
      "userSearchHistory",
      history.take(10).toList(),
    );
  }

  /// Retrieve the user search history.
  List<String> searchHistory() {
    return harpyPrefs.getStringList("userSearchHistory");
  }
}
