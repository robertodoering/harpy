import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final homeTabConfigurationProvider = StateNotifierProvider.autoDispose<
    HomeTabConfigurationNotifier, HomeTabConfiguration>(
  (ref) => HomeTabConfigurationNotifier(
    preferences: ref.watch(
      preferencesProvider(ref.watch(authPreferencesProvider).userId),
    ),
  ),
  name: 'HomeTabConfigurationProvider',
);

class HomeTabConfigurationNotifier extends StateNotifier<HomeTabConfiguration>
    with LoggerMixin {
  HomeTabConfigurationNotifier({required Preferences preferences})
      : _preferences = preferences,
        super(HomeTabConfiguration.defaultConfiguration()) {
    _initialize();
  }

  final Preferences _preferences;

  Future<void> _initialize() async {
    if (isFree) {
      state = HomeTabConfiguration.defaultConfiguration();
      return;
    }

    final json = _preferences.getString('homeTabConfiguration', '');

    if (json.isEmpty) {
      log.fine('no home tabs configuration exists');
      state = HomeTabConfiguration.defaultConfiguration();
    } else {
      try {
        final configuration = HomeTabConfiguration.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );

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
        _persistValue();
      }
    }
  }

  void setToDefault() {
    if (isFree) return;
    state = HomeTabConfiguration.defaultConfiguration();
    _persistValue();
  }

  /// Changes the ordering of the entries in the configuration.
  void reorder(int oldIndex, int newIndex) {
    if (isFree) return;
    log.fine('reordering from $oldIndex to $newIndex');

    final entry = state.entries[oldIndex];
    final index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    state = state.copyWith(
      entries: state.entries.rebuild(
        (builder) => builder
          ..removeAt(oldIndex)
          ..insert(index, entry),
      ),
    );

    _persistValue();
  }

  void toggleVisible(int index) {
    if (isFree) return;
    log.fine('toggling visibility for $index');

    state = state.copyWith(
      entries: state.entries.rebuild(
        (builder) => builder[index] = builder[index].copyWith(
          visible: !builder[index].visible,
        ),
      ),
    );

    _persistValue();
  }

  void changeName(int index, String name) {
    if (isFree) return;
    log.fine('changing name to $name');

    state = state.copyWith(
      entries: state.entries.rebuild(
        (builder) => builder[index] = builder[index].copyWith(name: name),
      ),
    );

    _persistValue();
  }

  void remove(int index) {
    if (isFree) return;
    log.fine('removing $index');

    if (state.entries[index].removable) {
      state = state.copyWith(
        entries: state.entries.rebuild(
          (builder) => builder.removeAt(index),
        ),
      );
    }

    _persistValue();
  }

  void changeIcon(int index, String icon) {
    if (isFree) return;
    log.fine('changing icon to $icon');

    state = state.copyWith(
      entries: state.entries.rebuild(
        (builder) => builder[index] = builder[index].copyWith(icon: icon),
      ),
    );

    _persistValue();
  }

  /// Adds a twitter list as a home tab entry to the configuration.
  ///
  /// When [icon] is `null`, the first letter of the name will be used as the
  /// icon. If the name is `null`, a random icon will be used instead.
  void addList({
    required TwitterListData list,
    String? icon,
  }) {
    if (isFree) return;
    if (!state.canAddMoreLists) return;
    log.fine('adding list ${list.name}');

    // randomize the icon if it's null (but skip the default icons)
    icon ??= list.name.isNotEmpty
        ? list.name[0]
        : (HomeTabEntryIcon.iconNameMap.keys.toList()
              ..skip(4)
              ..shuffle())
            .first;

    state = state.copyWith(
      entries: state.entries.rebuild(
        (builder) => builder.add(
          HomeTabEntry(
            id: list.id,
            type: HomeTabEntryType.list,
            icon: icon,
            name: list.name,
          ),
        ),
      ),
    );

    _persistValue();
  }

  /// Encodes the configuration and saves it into the preferences.
  void _persistValue() {
    try {
      _preferences.setString(
        'homeTabConfiguration',
        jsonEncode(state.toJson()),
      );
    } catch (e, st) {
      state = HomeTabConfiguration.defaultConfiguration();
      logErrorHandler(e, st);
    }
  }
}
