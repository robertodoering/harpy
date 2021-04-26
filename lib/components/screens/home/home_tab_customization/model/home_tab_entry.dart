import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_tab_entry.g.dart';

@immutable
@JsonSerializable()
class HomeTabEntry extends Equatable {
  const HomeTabEntry({
    @required this.id,
    @required this.type,
    @required this.icon,
    this.name = '',
    this.visible = true,
  });

  factory HomeTabEntry.fromJson(Map<String, dynamic> json) =>
      _$HomeTabEntryFromJson(json);

  /// The id for this entry.
  ///
  /// Represent a default view (e.g. 'home', 'search') or the id of a list
  /// when [type] is `list`.
  final String id;

  /// The type of this entry.
  ///
  /// Can be `default` for default views (e.g. 'home', 'search') or `list`
  /// when this entry is a list.
  final String type;

  /// The name of the icon that is used for the associated tab.
  final String icon;

  /// The name of this tab.
  ///
  /// Can be empty if the tab should not built text with the icon.
  final String name;

  /// Whether this tab should be visible or hidden.
  ///
  /// Only `default` tabs can be hidden. Lists can only be removed.
  final bool visible;

  @override
  List<Object> get props => <Object>[
        id,
        type,
        icon,
        name,
        visible,
      ];

  bool get valid => true; // todo

  bool get removable => type != HomeTabEntryType.defaultType.value;

  Map<String, dynamic> toJson() => _$HomeTabEntryToJson(this);

  HomeTabEntry copyWith({
    String id,
    String type,
    String icon,
    String name,
    bool visible,
  }) {
    return HomeTabEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      visible: visible ?? this.visible,
    );
  }
}

enum HomeTabEntryType {
  defaultType,
  list,
}

extension TypeExtension on HomeTabEntryType {
  String get value {
    switch (this) {
      case HomeTabEntryType.defaultType:
        return 'default';
      case HomeTabEntryType.list:
        return 'list';
    }

    assert(false, 'invalid type');

    return 'none';
  }
}
