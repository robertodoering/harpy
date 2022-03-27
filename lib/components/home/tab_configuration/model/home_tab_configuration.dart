import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';

part 'home_tab_configuration.freezed.dart';
part 'home_tab_configuration.g.dart';

@freezed
class HomeTabConfiguration with _$HomeTabConfiguration {
  factory HomeTabConfiguration({
    required List<HomeTabEntry> entries,
  }) = _HomeTabConfiguration;

  factory HomeTabConfiguration.defaultConfiguration() =>
      HomeTabConfiguration(entries: defaultHomeTabEntries);

  factory HomeTabConfiguration.fromJson(Map<String, dynamic> json) =>
      _$HomeTabConfigurationFromJson(json);

  HomeTabConfiguration._();

  /// The entries that are visible in the home screen.
  late final visibleEntries =
      entries.where((entry) => entry.visible ?? false).toBuiltList();

  late final defaultEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.defaultType)
      .toBuiltList();

  /// The entries that represent twitter lists in the home screen
  late final listEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.list)
      .toBuiltList();

  /// Whether the user can add more lists.
  late final canAddMoreLists = listEntries.length < 10;
}
