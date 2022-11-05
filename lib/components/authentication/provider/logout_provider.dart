import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Handles logout.
///
/// Authentication logic is split between
/// * [authenticationProvider]
/// * [loginProvider]
/// * [logoutProvider]
final logoutProvider = Provider(
  (ref) => Logout(ref: ref),
  name: 'LogoutProvider',
);

class Logout with LoggerMixin {
  const Logout({
    required Ref ref,
  }) : _ref = ref;

  final Ref _ref;

  /// Navigates to the [LoginPage] and invalidates the active session.
  Future<void> logout({
    String target = LoginPage.name,
  }) async {
    log.fine('logging out');

    _ref.read(routerProvider).goNamed(
      target,
      queryParams: {'transition': 'fade'},
    );

    // invalidate session after navigation to avoid building the home screen
    // without the user data
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _ref.read(authenticationProvider).onLogout();
  }
}
