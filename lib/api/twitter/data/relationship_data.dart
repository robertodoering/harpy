import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_data.freezed.dart';

@freezed
class RelationshipData with _$RelationshipData {
  const factory RelationshipData({
    @Default(false) bool blockedBy,
    @Default(false) bool blocking,
    @Default(false) bool canDm,
    @Default(false) bool followedBy,
    @Default(false) bool following,
    @Default(false) bool followingReceived,
    @Default(false) bool followingRequested,
    @Default(false) bool markedSpam,
    @Default(false) bool muting,
    @Default(false) bool wantRetweets,
  }) = _RelationshipData;

  factory RelationshipData.fromV1(Relationship relationship) {
    return RelationshipData(
      blockedBy: relationship.relationship?.source?.blockedBy ?? false,
      blocking: relationship.relationship?.source?.blocking ?? false,
      canDm: relationship.relationship?.source?.canDm ?? false,
      followedBy: relationship.relationship?.source?.followedBy ?? false,
      following: relationship.relationship?.source?.following ?? false,
      followingReceived:
          relationship.relationship?.source?.followingReceived ?? false,
      followingRequested:
          relationship.relationship?.source?.followingRequested ?? false,
      markedSpam: relationship.relationship?.source?.markedSpam ?? false,
      muting: relationship.relationship?.source?.muting ?? false,
      wantRetweets: relationship.relationship?.source?.wantRetweets ?? false,
    );
  }
}
