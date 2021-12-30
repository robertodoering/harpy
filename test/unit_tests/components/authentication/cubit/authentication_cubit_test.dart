import 'package:bloc_test/bloc_test.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_setup/mocks.dart';
import '../../../../test_setup/setup.dart';

class MockAuthPreferences extends Mock implements AuthPreferences {}

class MockTwitterAuth extends Mock implements TwitterAuth {}

void main() {
  late AuthenticationCubit authCubit;
  late ThemeBloc themeBloc;

  setUp(() async {
    await setupApp();
    app.registerLazySingleton<EnvConfig>(
      () => const MockAppConfig(
        twitterConsumerKey: 'key1,key2,key3',
        twitterConsumerSecret: 'secret1,secret2,secret3',
      ),
    );

    themeBloc = ThemeBloc(configCubit: ConfigCubit());
    authCubit = AuthenticationCubit(themeBloc: themeBloc);
  });

  tearDown(app.reset);

  group('authentication cubit', () {
    group('session restore', () {
      test('does nothing if no previous session exists', () async {
        await authCubit.restoreSession();

        expect(authCubit.state.isAuthenticated, isFalse);
      });

      test('restores a session with initialized user', () async {
        app<AuthPreferences>().userToken = 'token';
        app<AuthPreferences>().userSecret = 'secret';
        app<AuthPreferences>().userId = 'id';
        app<AuthPreferences>().auth = 0;

        when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
            .thenAnswer((_) async => User());

        await authCubit.restoreSession();

        expect(authCubit.state.isAuthenticated, isTrue);
      });

      test('invalidates session if requesting user failed', () async {
        app<AuthPreferences>().userToken = 'token';
        app<AuthPreferences>().userSecret = 'secret';
        app<AuthPreferences>().userId = 'id';
        app<AuthPreferences>().auth = 1;

        when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
            .thenAnswer((_) async => throw Exception());

        await authCubit.restoreSession();

        expect(authCubit.state.isAuthenticated, isFalse);
        expect(app<AuthPreferences>().userToken, isEmpty);
        expect(app<AuthPreferences>().userSecret, isEmpty);
        expect(app<AuthPreferences>().userId, isEmpty);

        // auth index should not be reset
        expect(app<AuthPreferences>().auth, equals(1));
      });

      blocTest<ThemeBloc, ThemeState>(
        'loads user themes after restoring sessions',
        build: () => themeBloc,
        act: (_) async {
          app<AuthPreferences>().userToken = 'token';
          app<AuthPreferences>().userSecret = 'secret';
          app<AuthPreferences>().userId = 'id';
          app<AuthPreferences>().auth = 0;

          app<HarpyPreferences>().prefix = 'id';
          app<ThemePreferences>().lightThemeId = 2;
          app<ThemePreferences>().darkThemeId = 1;

          when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
              .thenAnswer((_) async => User());

          await authCubit.restoreSession();
        },
        skip: 1,
        expect: () => [
          equals(
            themeBloc.state.copyWith(
              lightThemeData: predefinedThemes[2],
              darkThemeData: predefinedThemes[1],
            ),
          ),
        ],
      );
    });

    group('login', () {
      test('does nothing if app config is invalid', () async {
        app
          ..unregister<EnvConfig>()
          ..registerLazySingleton<EnvConfig>(
            () => const MockAppConfig(
              twitterConsumerKey: '',
              twitterConsumerSecret: '',
            ),
          );

        await authCubit.login();

        expect(authCubit.state.isAuthenticated, isFalse);
      });

      test(
          'successfully authenticates and navigates to setup screen if setup '
          'has not been performed before', () async {
        app
          ..unregister<AuthPreferences>()
          ..registerLazySingleton<AuthPreferences>(MockAuthPreferences.new);

        final twitterAuth = MockTwitterAuth();

        when(() => app<AuthPreferences>().initializeTwitterAuth())
            .thenReturn(twitterAuth);
        when(() => app<AuthPreferences>().auth).thenReturn(-1);

        when(
          () => twitterAuth.authenticateWithTwitter(
            webviewNavigation: any(named: 'webviewNavigation'),
            onExternalNavigation: any(named: 'onExternalNavigation'),
          ),
        ).thenAnswer(
          (_) async => TwitterAuthResult(
            status: TwitterAuthStatus.success,
            session: const TwitterAuthSession(
              token: 'token',
              tokenSecret: 'secret',
              userId: 'id',
            ),
          ),
        );

        when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
            .thenAnswer((_) async => User()..idStr = 'id');

        await authCubit.login();

        expect(authCubit.state.isAuthenticated, isTrue);
        expect(authCubit.state.user?.id, equals('id'));

        expect(app<HarpyPreferences>().prefix, equals('id'));

        verify(
          () => app<HarpyNavigator>().pushReplacementNamed(
            SetupScreen.route,
            type: RouteType.fade,
          ),
        );
      });

      test(
          'successfully authenticates and navigates to home screen if setup '
          'has been performed before', () async {
        app
          ..unregister<AuthPreferences>()
          ..registerLazySingleton<AuthPreferences>(MockAuthPreferences.new);

        app<HarpyPreferences>().prefix = 'id';
        app<SetupPreferences>().performedSetup = true;

        final twitterAuth = MockTwitterAuth();

        when(() => app<AuthPreferences>().initializeTwitterAuth())
            .thenReturn(twitterAuth);
        when(() => app<AuthPreferences>().auth).thenReturn(-1);

        when(
          () => twitterAuth.authenticateWithTwitter(
            webviewNavigation: any(named: 'webviewNavigation'),
            onExternalNavigation: any(named: 'onExternalNavigation'),
          ),
        ).thenAnswer(
          (_) async => TwitterAuthResult(
            status: TwitterAuthStatus.success,
            session: const TwitterAuthSession(
              token: 'token',
              tokenSecret: 'secret',
              userId: 'id',
            ),
          ),
        );

        when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
            .thenAnswer((_) async => User()..idStr = 'id');

        await authCubit.login();

        expect(authCubit.state.isAuthenticated, isTrue);
        expect(authCubit.state.user?.id, equals('id'));

        expect(app<HarpyPreferences>().prefix, equals('id'));

        verify(
          () => app<HarpyNavigator>().pushReplacementNamed(
            HomeScreen.route,
            type: RouteType.fade,
          ),
        );
      });

      test('navigates back to login screen on unsuccessful authentication',
          () async {
        app
          ..unregister<AuthPreferences>()
          ..registerLazySingleton<AuthPreferences>(MockAuthPreferences.new);

        final twitterAuth = MockTwitterAuth();

        when(() => app<AuthPreferences>().initializeTwitterAuth())
            .thenReturn(twitterAuth);
        when(() => app<AuthPreferences>().auth).thenReturn(-1);

        when(
          () => twitterAuth.authenticateWithTwitter(
            webviewNavigation: any(named: 'webviewNavigation'),
            onExternalNavigation: any(named: 'onExternalNavigation'),
          ),
        ).thenAnswer(
          (_) async => TwitterAuthResult(status: TwitterAuthStatus.failure),
        );

        await authCubit.login();

        expect(authCubit.state.isAuthenticated, isFalse);
        verify(
          () => app<HarpyNavigator>().pushReplacementNamed(
            LoginScreen.route,
            type: RouteType.fade,
          ),
        );
      });

      test(
          'navigates back to login screen when authentication was successful '
          'but user was unable to be requested', () async {
        app
          ..unregister<AuthPreferences>()
          ..registerLazySingleton<AuthPreferences>(MockAuthPreferences.new);

        final twitterAuth = MockTwitterAuth();

        when(() => app<AuthPreferences>().initializeTwitterAuth())
            .thenReturn(twitterAuth);
        when(() => app<AuthPreferences>().auth).thenReturn(-1);

        when(
          () => twitterAuth.authenticateWithTwitter(
            webviewNavigation: any(named: 'webviewNavigation'),
            onExternalNavigation: any(named: 'onExternalNavigation'),
          ),
        ).thenAnswer(
          (_) async => TwitterAuthResult(
            status: TwitterAuthStatus.success,
            session: const TwitterAuthSession(
              token: 'token',
              tokenSecret: 'secret',
              userId: 'id',
            ),
          ),
        );

        when(() => app<TwitterApi>().userService.usersShow(userId: 'id'))
            .thenAnswer((_) async => throw Exception());

        await authCubit.login();

        expect(authCubit.state.isAuthenticated, isFalse);

        verify(
          () => app<HarpyNavigator>().pushReplacementNamed(
            LoginScreen.route,
            type: RouteType.fade,
          ),
        );
      });
    });

    group('logout', () {
      test('navigates to login screen and invalidates session', () async {
        app<AuthPreferences>().userToken = 'token';
        app<AuthPreferences>().userSecret = 'secret';
        app<AuthPreferences>().userId = 'id';

        await authCubit.logout(delay: Duration.zero);

        expect(app<AuthPreferences>().userToken, equals(''));
        expect(app<AuthPreferences>().userSecret, equals(''));
        expect(app<AuthPreferences>().userId, equals(''));

        expect(authCubit.state.isAuthenticated, isFalse);

        verify(
          () => app<HarpyNavigator>().pushReplacementNamed(LoginScreen.route),
        );
      });

      blocTest<ThemeBloc, ThemeState>(
        'resets theme to the default theme',
        build: () => themeBloc,
        seed: () => themeBloc.state.copyWith(
          lightThemeData: predefinedThemes[2],
          darkThemeData: predefinedThemes[2],
        ),
        act: (_) => authCubit.logout(delay: Duration.zero),
        expect: () => [
          equals(
            themeBloc.state.copyWith(
              lightThemeData: predefinedThemes[0],
              darkThemeData: predefinedThemes[0],
            ),
          ),
        ],
      );
    });

    group('twitter auth initialization', () {
      test('sets auth if not previously set', () {
        app<AuthPreferences>().initializeTwitterAuth();

        expect(app<AuthPreferences>().auth, isNot(-1));
      });

      test('uses previously set index', () {
        app<AuthPreferences>().auth = 2;

        final auth = app<AuthPreferences>().initializeTwitterAuth();

        expect(auth.consumerKey, equals('key3'));
        expect(auth.consumerSecret, equals('secret3'));
      });

      test('uses the first set as a fallback', () {
        app<AuthPreferences>().auth = 69;

        final auth = app<AuthPreferences>().initializeTwitterAuth();

        expect(auth.consumerKey, equals('key1'));
        expect(auth.consumerSecret, equals('secret1'));
      });

      test('can use a single set of credentials', () {
        app
          ..unregister<EnvConfig>()
          ..registerLazySingleton<EnvConfig>(
            () => const MockAppConfig(
              twitterConsumerKey: 'key',
              twitterConsumerSecret: 'secret',
            ),
          );

        final auth = app<AuthPreferences>().initializeTwitterAuth();

        expect(app<AuthPreferences>().auth, equals(0));
        expect(auth.consumerKey, equals('key'));
        expect(auth.consumerSecret, equals('secret'));
      });
    });
  });
}
