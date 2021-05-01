import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_tab_configuration.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class HomeTabConfiguration extends Equatable {
  const HomeTabConfiguration({
    @required this.entries,
  });

  factory HomeTabConfiguration.fromJson(Map<String, dynamic> json) =>
      _$HomeTabConfigurationFromJson(json);

  final List<HomeTabEntry> entries;

  static const HomeTabConfiguration empty = HomeTabConfiguration(
    entries: <HomeTabEntry>[],
  );

  static final HomeTabConfiguration defaultConfiguration = HomeTabConfiguration(
    entries: defaultHomeTabEntries,
  );

  @override
  List<Object> get props => <Object>[
        entries,
      ];

  Map<String, dynamic> toJson() => _$HomeTabConfigurationToJson(this);

  HomeTabConfiguration addEntry(HomeTabEntry entry, [int index]) {
    return HomeTabConfiguration(
      entries: index != null
          ? (List<HomeTabEntry>.of(entries)..insert(index, entry))
          : (List<HomeTabEntry>.of(entries)..add(entry)),
    );
  }

  HomeTabConfiguration removeEntry(int index) {
    return HomeTabConfiguration(
      entries: List<HomeTabEntry>.of(entries)..removeAt(index),
    );
  }

  HomeTabConfiguration updateEntry(int index, HomeTabEntry entry) {
    final List<HomeTabEntry> newEntries = List<HomeTabEntry>.from(entries);
    newEntries[index] = entry;

    return HomeTabConfiguration(
      entries: newEntries,
    );
  }
}
