import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_setup/data/user_data.dart';
import '../../test_setup/mocks.dart';

void main() {
  group('application', () {
    test('navigates to the login screen after initialization', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          routerProvider.overrideWithValue(MockRouter()),
          connectivityProvider.overrideWith(
            (ref) => MockConnectivityNotifier(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(applicationProvider).initialize();
      verify(
        () => container.read(routerProvider).goNamed(
              LoginPage.name,
              queryParams: any(named: 'queryParams'),
            ),
      ).called(1);
    });

    test(
        'navigates to the home screen after initialization when user is '
        'already authenticated', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          routerProvider.overrideWithValue(MockRouter()),
          connectivityProvider.overrideWith(
            (ref) => MockConnectivityNotifier(),
          ),
          authenticationStateProvider.overrideWith(
            (ref) => AuthenticationState.authenticated(user: harpyAppUser),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(applicationProvider).initialize();
      verify(
        () => container.read(routerProvider).goNamed(
              HomePage.name,
              queryParams: any(named: 'queryParams'),
            ),
      ).called(1);
    });
  });
}
