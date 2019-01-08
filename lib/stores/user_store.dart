import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/config/app_configuration.dart';
import 'package:logging/logging.dart';

class UserStore extends Store {
  final Logger log = Logger("UserStore");

  static final Action initLoggedInUser = Action();
  static final Action updateLoggedInUser = Action();

  static final Action<User> initUser = Action();
  static final Action<String> initUserFromId = Action();
  static final Action<String> updateUserFromId = Action();

  static final Action<String> initUserTweetsFromId = Action();

  User _loggedInUser;
  User get loggedInUser => _loggedInUser;

  /// The [User] to display.
  User _user;
  User get user => _user;

  /// The [Tweet]s for the [user].
  List<Tweet> _userTweets;
  List<Tweet> get userTweets => _userTweets;

  UserStore() {
    /*
     * logged in user
     */
    initLoggedInUser.listen((_) async {
      String userId = AppConfiguration().twitterSession.userId;
      log.fine("init logged in user for $userId");

      _loggedInUser = UserCache().getCachedUser(userId);

      if (_loggedInUser == null) {
        await updateLoggedInUser();
      } else {
        updateLoggedInUser();
      }
    });

    triggerOnAction(updateLoggedInUser, (_) async {
      log.fine("updating logged in user");
      String userId = AppConfiguration().twitterSession.userId;

      _loggedInUser = await UserService().getUserDetails(id: userId);
    });

    /*
     * user
     */
    initUser.listen((User user) => _user = user);

    initUserFromId.listen((String userId) async {
      User user = UserCache().getCachedUser(userId);

      if (user != null) {
        _user = user;
        trigger();
      } else {
        await updateUserFromId(userId);
      }
    });

    triggerOnAction(updateUserFromId, (String userId) async {
      log.fine("updating user");
      User user =
          await UserService().getUserDetails(id: userId).catchError((_) {
        log.warning("unable to update user");
        return null;
      });

      if (user != null) {
        _user = user;
      }
    });

    /*
     * user tweets
     */
    initUserTweetsFromId.listen((String userId) async {
//      _userTweets = TweetCache.user(userId).getCachedTweets();

      // todo: cache user tweets
      _userTweets = await TweetService().getUserTimeline(userId: userId);
    });
  }
}
