import 'dart:math';

import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

class AuthPreferences {
  const AuthPreferences();

  String get userToken => app<HarpyPreferences>().getString('userToken', '');
  set userToken(String value) =>
      app<HarpyPreferences>().setString('userToken', value);

  String get userSecret => app<HarpyPreferences>().getString('userSecret', '');
  set userSecret(String value) =>
      app<HarpyPreferences>().setString('userSecret', value);

  String get userId => app<HarpyPreferences>().getString('userId', '');
  set userId(String value) =>
      app<HarpyPreferences>().setString('userId', value);

  int get auth => app<HarpyPreferences>().getInt('auth', -1);
  set auth(int value) => app<HarpyPreferences>().setInt('auth', value);

  TwitterAuth initializeTwitterAuth() {
    if (app<AuthPreferences>().auth == -1) {
      final count = app<EnvConfig>().credentialsCount;

      app<AuthPreferences>().auth = Random().nextInt(count);
    }

    final key = app<EnvConfig>().key(app<AuthPreferences>().auth);
    final secret = app<EnvConfig>().secret(app<AuthPreferences>().auth);

    return TwitterAuth(
      consumerKey: key,
      consumerSecret: secret,
    );
  }

  void clearAuth() {
    app<HarpyPreferences>()
      ..remove('userToken')
      ..remove('userSecret')
      ..remove('userId');
  }
}
