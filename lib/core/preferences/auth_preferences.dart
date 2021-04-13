import 'package:harpy/core/core.dart';

class AuthPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();
  final HarpyInfo harpyInfo = app<HarpyInfo>();

  String get userToken => harpyPrefs.getString('userToken', null);
  set userToken(String value) => harpyPrefs.setString('userToken', value);

  String get userSecret => harpyPrefs.getString('userSecret', null);
  set userSecret(String value) => harpyPrefs.setString('userSecret', value);

  String get userId => harpyPrefs.getString('userId', null);
  set userId(String value) => harpyPrefs.setString('userId', value);
}
