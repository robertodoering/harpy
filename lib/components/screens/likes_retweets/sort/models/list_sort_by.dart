import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_sort_by.g.dart';

@JsonSerializable()
class ListSortBy extends Equatable {
  const ListSortBy({
    this.byFollowing = false,
    this.byFollowers = false,
    this.byHandle = false,
    this.byDisplayName = false,
  });

  factory ListSortBy.fromJson(Map<String, dynamic> json) =>
      _$ListSortByFromJson(json);

  factory ListSortBy.fromJsonString(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return ListSortBy.empty;
      } else {
        return ListSortBy.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // unable to decode sort order
      return ListSortBy.empty;
    }
  }

  final bool byFollowing;
  final bool byFollowers;
  final bool byHandle;
  final bool byDisplayName;

  static const ListSortBy empty = ListSortBy();

  @override
  List<Object> get props => <Object>[
    byFollowing,
    byFollowers,
    byHandle,
    byDisplayName,
  ];

  Map<String, dynamic> toJson() => _$ListSortByToJson(this);

  ListSortBy copyWith({
    bool? byFollowing,
    bool? byFollowers,
    bool? byHandle,
    bool? byDisplayName,
  }) {
    return ListSortBy(
      byFollowing: byFollowing ?? this.byFollowing,
      byFollowers: byFollowers ?? this.byFollowers,
      byHandle: byHandle ?? this.byHandle,
      byDisplayName: byDisplayName ?? this.byDisplayName,
    );
  }
}
