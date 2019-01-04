import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/core/config/app_configuration.dart';
import 'package:logging/logging.dart';

class UserStore extends Store {
  final Logger log = Logger("UserStore");

  static final Action initLoggedInUser = Action();
  static final Action<User> initUserTweets = Action();

  User _loggedInUser;

  User get loggedInUser => _loggedInUser;

  List<Tweet> _userTweets;

  List<Tweet> get userTweets => _userTweets;

  UserStore() {
    initLoggedInUser.listen((_) async {
      String userId = AppConfiguration().twitterSession.userId;

      // todo: cache user and load from cache

      _loggedInUser = await UserService().getUserDetails(userId);

      log.fine("loaded user: $_loggedInUser");
    });

    initUserTweets.listen((User user) async {
      _userTweets = await TweetService().getUserTimeline("${user.id}");
    });
  }
}
