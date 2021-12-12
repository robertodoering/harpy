import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_sort_by.g.dart';

@JsonSerializable()
class UserSortBy extends Equatable {
  const UserSortBy({
    this.following = false,
    this.followers = false,
    this.handle = false,
    this.displayName = false,
  });

  factory UserSortBy.fromJson(Map<String, dynamic> json) =>
      _$UserSortByFromJson(json);

  factory UserSortBy.fromJsonString(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return UserSortBy.empty;
      } else {
        return UserSortBy.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // unable to decode sort order
      return UserSortBy.empty;
    }
  }

  final bool following;
  final bool followers;
  final bool handle;
  final bool displayName;

  static const UserSortBy empty = UserSortBy();

  @override
  List<Object> get props => <Object>[
    following,
    followers,
    handle,
    displayName,
  ];

  Map<String, dynamic> toJson() => _$UserSortByToJson(this);

  UserSortBy copyWith({
    bool? following,
    bool? followers,
    bool? handle,
    bool? displayName,
  }) {
    return UserSortBy(
      following: following ?? this.following,
      followers: followers ?? this.followers,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
    );
  }
}
