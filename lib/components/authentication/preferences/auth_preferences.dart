import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'auth_preferences.freezed.dart';

/// Handles storing and updating the authentication data for a sessions.
final authPreferencesProvider =
    StateNotifierProvider<AuthPreferencesNotifier, AuthPreferences>(
  (ref) => AuthPreferencesNotifier(
    preferences: ref.watch(encryptedPreferencesProvider(null)),
  ),
  name: 'AuthPreferencesProvider',
);

class AuthPreferencesNotifier extends StateNotifier<AuthPreferences> {
  AuthPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          AuthPreferences(
            userToken: preferences.getString('userToken', ''),
            userSecret: preferences.getString('userSecret', ''),
            userId: preferences.getString('userId', ''),
          ),
        );

  final Preferences _preferences;

  void setAuth({
    required String token,
    required String secret,
    required String userId,
  }) {
    state = AuthPreferences(
      userToken: token,
      userSecret: secret,
      userId: userId,
    );

    _preferences
      ..setString('userToken', token)
      ..setString('userSecret', secret)
      ..setString('userId', userId);
  }

  void clearAuth() {
    state = AuthPreferences.empty();

    _preferences
      ..remove('userToken')
      ..remove('userSecret')
      ..remove('userId');
  }
}

@freezed
class AuthPreferences with _$AuthPreferences {
  factory AuthPreferences({
    required String userToken,
    required String userSecret,
    required String userId,
  }) = _AuthPreferences;

  factory AuthPreferences.empty() => AuthPreferences(
        userToken: '',
        userSecret: '',
        userId: '',
      );

  AuthPreferences._();

  late final bool isValid =
      userToken.isNotEmpty && userSecret.isNotEmpty && userId.isNotEmpty;
}
