import 'package:bloc_test/bloc_test.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_state.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/connectivity_service.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/preferences/general_preferences.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:mockito/mockito.dart';

class MockAppConfig extends Mock implements AppConfig {}

class MockHarpyInfo extends Mock implements HarpyInfo {}

class MockErrorReporter extends Mock implements ErrorReporter {}

class MockTwitterApi extends Mock implements TwitterApi {}

class MockHarpyPreferences extends Mock implements HarpyPreferences {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    app.registerLazySingleton<TwitterApi>(() => MockTwitterApi());
    app.registerLazySingleton<AppConfig>(() => MockAppConfig());
    app.registerLazySingleton<ErrorReporter>(() => MockErrorReporter());
    app.registerLazySingleton<HarpyInfo>(() => MockHarpyInfo());
    app.registerLazySingleton<HarpyPreferences>(() => MockHarpyPreferences());
    app.registerLazySingleton<HarpyNavigator>(() => HarpyNavigator());
    app.registerLazySingleton<ChangelogPreferences>(
        () => ChangelogPreferences());
    app.registerLazySingleton<GeneralPreferences>(() => GeneralPreferences());
    app.registerLazySingleton<ConnectivityService>(
      () => MockConnectivityService(),
    );
  });

  tearDown(app.reset);

  blocTest<ApplicationBloc, ApplicationState>(
    'application bloc initializes the app with empty app config data',
    build: () {
      when(app<AppConfig>().initialize()).thenAnswer((_) async {});
      when(app<HarpyInfo>().initialize()).thenAnswer((_) async {});
      when(app<ErrorReporter>().initialize()).thenAnswer((_) async {});
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
      verify(app<AppConfig>().initialize());
      verify(app<HarpyInfo>().initialize());
      verify(app<ErrorReporter>().initialize());
      verify(app<HarpyPreferences>().initialize());
      verify(app<ConnectivityService>().initialize());

      expect(bloc.authenticationBloc.state, isA<UnauthenticatedState>());
    },
  );
}
