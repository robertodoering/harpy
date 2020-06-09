import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

mixin PaginatedModel on ChangeNotifier {
  static final Logger _log = Logger("PaginatedModel");

  /// `true` while the data is initially loaded.
  bool _loading = true;
  bool get loading => _loading;

  /// Whether or not all data has been searched for.
  bool lastPage = false;

  /// Loads the initial set of data by calling [search].
  ///
  /// Sets the [_loading] flag to `false` after [search] completes.
  @protected
  Future<void> initialize() async {
    await search();
    _loading = false;

    notifyListeners();
  }

  /// Calls [search] to load the next page of data.
  Future<void> loadMore() async {
    if (lastPage) {
      _log.warning("tried to load more when already on the last page");
      return;
    }

    await search();

    notifyListeners();
  }

  /// Overridden to request the data.
  ///
  /// Calling [search] should request the next available page of data.
  /// If the last page has been requested, [lastPage] should be set to `true`.
  @protected
  Future<void> search();
}
