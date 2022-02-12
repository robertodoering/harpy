import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'home_tab_configuration.freezed.dart';
part 'home_tab_configuration.g.dart';

@freezed
class HomeTabConfiguration with _$HomeTabConfiguration {
  factory HomeTabConfiguration({
    required List<HomeTabEntry> entries,
  }) = _HomeTabConfiguration;

  factory HomeTabConfiguration.empty() => HomeTabConfiguration(entries: []);

  factory HomeTabConfiguration.defaultConfiguration() =>
      HomeTabConfiguration(entries: defaultHomeTabEntries);

  factory HomeTabConfiguration.fromJson(Map<String, dynamic> json) =>
      _$HomeTabConfigurationFromJson(json);

  HomeTabConfiguration._();

  /// The entries that are visible in the home screen.
  late final BuiltList visibleEntries =
      entries.where((entry) => entry.visible ?? false).toBuiltList();

  late final BuiltList defaultEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.defaultType)
      .toBuiltList();

  /// The entries that represent twitter lists in the home screen
  late final BuiltList listEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.list)
      .toBuiltList();

  /// Whether the user can add more lists.
  ///
  /// In the free version, only one list can be added.
  /// In the pro version, up to 10 lists can be added.
  bool get canAddMoreLists =>
      isFree && listEntries.isEmpty || isPro && listEntries.length < 10;
}
