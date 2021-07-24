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

  void clearAuth() {
    harpyPrefs.remove('userToken');
    harpyPrefs.remove('userSecret');
    harpyPrefs.remove('userId');
  }
}
