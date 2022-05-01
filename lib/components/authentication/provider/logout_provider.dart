import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Handles logout.
///
/// Authentication logic is split between
/// * [authenticationProvider]
/// * [loginProvider]
/// * [logoutProvider]
final logoutProvider = Provider(
  (ref) => Logout(read: ref.read),
  name: 'LogoutProvider',
);

class Logout with LoggerMixin {
  const Logout({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  /// Navigates to the [LoginPage] and invalidates the active session.
  Future<void> logout() async {
    log.fine('logging out');

    _read(routerProvider).goNamed(
      LoginPage.name,
      queryParams: {'origin': 'home'},
    );

    // invalidate session after navigation to avoid building the home screen
    // without the user data
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _read(authenticationProvider).onLogout();
  }
}
