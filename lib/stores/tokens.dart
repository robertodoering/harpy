import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:logging/logging.dart';

class Tokens {
  static final StoreToken home = StoreToken(HomeStore());
  static final StoreToken login = StoreToken(LoginStore());
  static final StoreToken user = StoreToken(UserStore());

  Tokens() {
    Logger("Tokens").finest("init tokens");
    login;
    home;
    user;
  }
}
