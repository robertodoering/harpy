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
  _Logout.new,
  name: 'LogoutProvider',
);

class _Logout with LoggerMixin {
  const _Logout(this._ref);

  final Ref _ref;

  /// Navigates to the [LoginPage] and invalidates the active session.
  Future<void> logout() async {
    log.fine('logging out');

    _ref.read(routerProvider).goNamed(
      LoginPage.name,
      queryParams: {'origin': 'home'},
    );

    // invalidate session after navigation to avoid building the home screen
    // without the user data
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _ref.read(authenticationProvider).onLogout();
  }
}
