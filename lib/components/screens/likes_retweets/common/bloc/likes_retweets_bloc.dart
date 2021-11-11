import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

part 'likes_retweets_event.dart';

/// An abstraction for the [LikesBloc] and the [RetweetsBloc].
abstract class LikesRetweetsBloc extends PaginatedBloc {
  LikesRetweetsBloc({
    required this.tweetId,
    this.sort,
  });

  /// The id of the user for whom to load the following users.
  final String? tweetId;

  //TODO we need either an enum type with all the filtering options or a string list that has all options
  final String? sort;

  /// The list of retweeting/liking users for the tweet with the [tweetId].
  List<UserData> users = [];

  @override
  bool get hasData => users.isNotEmpty;

  @override
  Duration get lockDuration => const Duration(seconds: 5);
}
