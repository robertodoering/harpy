import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

final homeTabConfigurationProvider = StateNotifierProvider.autoDispose<
    HomeTabConfigurationNotifier, HomeTabConfiguration>(
  (ref) => HomeTabConfigurationNotifier(
    preferences: ref.watch(
      preferencesProvider(ref.watch(authPreferencesProvider).userId),
    ),
  ),
  name: 'HomeTabsProvider',
);

class HomeTabConfigurationNotifier extends StateNotifier<HomeTabConfiguration>
    with LoggerMixin {
  HomeTabConfigurationNotifier({required Preferences preferences})
      : _preferences = preferences,
        super(HomeTabConfiguration.empty()) {
    _initialize();
  }

  final Preferences _preferences;

  Future<void> _initialize() async {
    final json = _preferences.getString('homeTabConfiguration', '');

    if (json.isEmpty) {
      log.fine('no home tabs configuration exists');
      state = HomeTabConfiguration.defaultConfiguration();
    } else {
      try {
        final configuration = HomeTabConfiguration.fromJson(jsonDecode(json));

        // verify configuration validity
        if (configuration.defaultEntries.length !=
            defaultHomeTabEntries.length) {
          throw Exception(
            'invalid default tabs count: '
            '${configuration.defaultEntries.length}\n'
            'expected ${defaultHomeTabEntries.length}',
          );
        } else if (configuration.entries.any((entry) => !entry.valid)) {
          throw Exception('invalid entry in configuration');
        } else if (isFree && configuration.listEntries.length > 1 ||
            isPro && configuration.listEntries.length > 10) {
          throw Exception('invalid list count');
        }

        log.fine('initialized home tabs configuration');
        state = configuration;
      } catch (e, st) {
        log.severe('invalid home tabs configuration $json', e, st);
        state = HomeTabConfiguration.defaultConfiguration();
        // TODO: persist value
      }
    }
  }

  // TODO: add methods to update the value
}
