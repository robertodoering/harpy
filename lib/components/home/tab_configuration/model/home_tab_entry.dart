import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';

part 'home_tab_entry.freezed.dart';
part 'home_tab_entry.g.dart';

enum HomeTabEntryType {
  defaultType,
  list,
}

// FIXME: Implement a better data structure that allows for custom data based on
// the type (e.g. id and name for a list)

@freezed
class HomeTabEntry with _$HomeTabEntry {
  factory HomeTabEntry({
    /// The id for this entry.
    ///
    /// Represent a default view (e.g. 'home', 'search') or the id of a list
    /// when [type] is `list`.
    required String id,

    /// The type of this entry.
    ///
    /// Can be `default` for default views (e.g. 'home', 'search') or `list`
    /// when this entry is a list.
    required HomeTabEntryType? type,

    /// The name of the icon that is used for the associated tab.
    required String? icon,

    /// The name of this tab.
    ///
    /// Can be empty if the tab should not built text with the icon.
    @Default('') String name,

    /// Whether this tab should be visible or hidden.
    ///
    /// Only `default` tabs can be hidden. Lists can only be removed.
    @Default(true) bool visible,
  }) = _HomeTabEntry;

  factory HomeTabEntry.fromJson(Map<String, dynamic> json) =>
      _$HomeTabEntryFromJson(json);

  HomeTabEntry._();

  /// Whether the entry can be removed from the configuration.
  late final bool removable = type != HomeTabEntryType.defaultType;

  /// Whether we can assume that the entry is correct and has not been
  /// modified externally.
  late final bool valid = type != HomeTabEntryType.defaultType ||
      defaultHomeTabEntries.where((entry) => entry.id == id).isNotEmpty;
}
