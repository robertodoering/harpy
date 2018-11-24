import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/user/user_service_impl.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:logging/logging.dart';

class UserStore extends Store {
  final Logger log = Logger("UserStore");

  static final Action initLoggedInUser = Action();

  User _loggedInUser;

  User get loggedInUser => _loggedInUser;

  UserStore() {
    initLoggedInUser.listen((_) async {
      String userId = AppConfiguration().twitterSession.userId;

      _loggedInUser = await UserServiceImpl().getUserDetails(id: userId);

      log.fine("loaded user: $_loggedInUser");
    });
  }
}
