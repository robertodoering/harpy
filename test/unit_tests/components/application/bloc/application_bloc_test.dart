import 'package:bloc_test/bloc_test.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:mockito/mockito.dart';

class MockHarpyInfo extends Mock implements HarpyInfo {}

class MockTwitterApi extends Mock implements TwitterApi {}

class MockHarpyPreferences extends Mock implements HarpyPreferences {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    app.registerLazySingleton<TwitterApi>(() => MockTwitterApi());
    app.registerLazySingleton<HarpyInfo>(() => MockHarpyInfo());
    app.registerLazySingleton<HarpyPreferences>(() => MockHarpyPreferences());
    app.registerLazySingleton<HarpyNavigator>(() => HarpyNavigator());
    app.registerLazySingleton<ChangelogPreferences>(
        () => ChangelogPreferences());
    app.registerLazySingleton<GeneralPreferences>(() => GeneralPreferences());
    app.registerLazySingleton<AuthPreferences>(() => AuthPreferences());
    app.registerLazySingleton<ConnectivityService>(
      () => MockConnectivityService(),
    );
  });

  tearDown(app.reset);

  blocTest<ApplicationBloc, ApplicationState>(
    'application bloc initializes the app with empty app config data',
    build: () {
      when(app<HarpyInfo>().initialize()).thenAnswer((_) async {});
      when(app<HarpyPreferences>().initialize()).thenAnswer((_) async {});
      when(app<ConnectivityService>().initialize()).thenAnswer((_) async {});
      when(app<GeneralPreferences>().performanceMode).thenReturn(false);
      final ThemeBloc themeBloc = ThemeBloc();

      return ApplicationBloc(
        authenticationBloc: AuthenticationBloc(themeBloc: themeBloc),
        themeBloc: themeBloc,
      );
    },
    verify: (ApplicationBloc bloc) async {
      verify(app<HarpyInfo>().initialize());
      verify(app<HarpyPreferences>().initialize());
      verify(app<ConnectivityService>().initialize());

      expect(bloc.authenticationBloc.state, isA<UnauthenticatedState>());
    },
  );
}
