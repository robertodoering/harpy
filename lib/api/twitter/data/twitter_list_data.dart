import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';

class TwitterListData {
  TwitterListData.fromTwitterList(TwitterList list) {
    name = list.name ?? '';
    createdAt = list.createdAt;
    subscriberCount = list.subscriberCount;
    idStr = list.idStr ?? '';
    memberCount = list.memberCount;
    mode = list.mode ?? 'public';
    description = list.description;
    user = list.user != null ? UserData.fromUser(list.user) : null;
    following = list.following ?? false;
  }

  late String name;
  DateTime? createdAt;
  int? subscriberCount;
  late String idStr;
  int? memberCount;

  /// Can be 'private' or 'public'.
  late String mode;

  String? description;
  UserData? user;
  late bool following;

  /// Whether a description for this list exist.
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Whether is is a private list.
  bool get isPrivate => mode == 'private';

  /// Whether this is a public list.
  bool get isPublic => mode == 'public';
}
