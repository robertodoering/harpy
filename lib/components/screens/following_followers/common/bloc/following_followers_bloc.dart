import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'following_followers_event.dart';

/// An abstraction for the [FollowersBloc] and the [FollowingBloc].
abstract class FollowingFollowersBloc extends PaginatedBloc {
  FollowingFollowersBloc({
    required this.userId,
  });

  /// The id of the user for whom to load the following users.
  final String? userId;

  final UserService userService = app<TwitterApi>().userService;

  /// The list of following users for the user with the [userId].
  List<UserData> users = <UserData>[];

  @override
  bool get hasData => users.isNotEmpty;

  @override
  Duration get lockDuration => const Duration(seconds: 5);
}
