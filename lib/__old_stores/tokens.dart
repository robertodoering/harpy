import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/__old_stores/home_store.dart';
import 'package:harpy/__old_stores/login_store.dart';
import 'package:harpy/__old_stores/settings_store.dart';
import 'package:harpy/__old_stores/user_store.dart';
import 'package:logging/logging.dart';

class Tokens {
  static final StoreToken home = StoreToken(HomeStore());
  static final StoreToken login = StoreToken(LoginStore());
  static final StoreToken user = StoreToken(UserStore());
  static final StoreToken settings = StoreToken(SettingsStore());

  Tokens() {
    Logger("Tokens").finest("init tokens");
    login;
    home;
    user;
    settings;
  }
}
