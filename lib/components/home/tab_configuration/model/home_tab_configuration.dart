import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'home_tab_configuration.freezed.dart';
part 'home_tab_configuration.g.dart';

@freezed
class HomeTabConfiguration with _$HomeTabConfiguration {
  factory HomeTabConfiguration({
    @_EntriesConverter() required BuiltList<HomeTabEntry> entries,
  }) = _HomeTabConfiguration;

  factory HomeTabConfiguration.defaultConfiguration() =>
      HomeTabConfiguration(entries: defaultHomeTabEntries);

  factory HomeTabConfiguration.fromJson(Map<String, dynamic> json) =>
      _$HomeTabConfigurationFromJson(json);

  HomeTabConfiguration._();

  late final visibleEntries =
      entries.where((entry) => entry.visible).toBuiltList();

  late final defaultEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.defaultType)
      .toBuiltList();

  late final listEntries = entries
      .where((entry) => entry.type == HomeTabEntryType.list)
      .toBuiltList();

  late final canAddMoreLists = listEntries.length < 10;
}

class _EntriesConverter extends BuiltListConverter<HomeTabEntry> {
  const _EntriesConverter();

  @override
  HomeTabEntry valueFromJson(Map<String, dynamic> json) =>
      HomeTabEntry.fromJson(json);
}
