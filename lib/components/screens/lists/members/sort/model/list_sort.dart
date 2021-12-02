import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_sort.g.dart';

@JsonSerializable()
class ListSort extends Equatable {
  const ListSort({
    this.handle = false,
    this.followers = false,
    this.following = false,
    this.displayName = false,
  });

  factory ListSort.fromJson(Map<String, dynamic> json) =>
      _$ListSortFromJson(json);

  factory ListSort.fromJsonString(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return ListSort.empty;
      } else {
        return ListSort.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // unable to decode timeline filter
      return ListSort.empty;
    }
  }

  final bool handle;
  final bool followers;
  final bool following;
  final bool displayName;

  static const ListSort empty = ListSort();

  @override
  List<Object> get props => <Object>[
    handle,
    followers,
    following,
    displayName,
  ];

  Map<String, dynamic> toJson() => _$ListSortToJson(this);

  ListSort copyWith({
    bool? handle,
    bool? followers,
    bool? following,
    bool? displayName,
  }) {
    return ListSort(
      handle: handle ?? this.handle,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      displayName: displayName ?? this.displayName,
    );
  }
}
