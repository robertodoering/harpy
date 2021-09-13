import 'dart:math';

import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

class AuthPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  String get userToken => harpyPrefs.getString('userToken', '')!;
  set userToken(String value) => harpyPrefs.setString('userToken', value);

  String get userSecret => harpyPrefs.getString('userSecret', '')!;
  set userSecret(String value) => harpyPrefs.setString('userSecret', value);

  String get userId => harpyPrefs.getString('userId', '')!;
  set userId(String value) => harpyPrefs.setString('userId', value);

  int get auth => harpyPrefs.getInt('auth', -1);
  set auth(int value) => harpyPrefs.setInt('auth', value);

  TwitterAuth initializeTwitterAuth() {
    if (app<AuthPreferences>().auth == -1) {
      final count = app<AppConfig>().credentialsCount;

      app<AuthPreferences>().auth = Random().nextInt(count);
    }

    final key = app<AppConfig>().key(app<AuthPreferences>().auth);
    final secret = app<AppConfig>().secret(app<AuthPreferences>().auth);

    return TwitterAuth(
      consumerKey: key,
      consumerSecret: secret,
    );
  }

  void clearAuth() {
    harpyPrefs
      ..remove('userToken')
      ..remove('userSecret')
      ..remove('userId');
  }
}
