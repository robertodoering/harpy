import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';

class HomeTabModel extends ValueNotifier<List<HomeTabEntry>> with HarpyLogger {
  HomeTabModel() : super(<HomeTabEntry>[]) {
    _initialize();
  }

  final HomeTabPreferences homeTabPreferences = app<HomeTabPreferences>();

  void _initialize() {
    final String configurationJson = homeTabPreferences.homeTabEntries;

    if (configurationJson.isEmpty) {
      log.fine('no configuration exists');

      value = defaultHomeTabEntries;
    } else {
      try {
        final List<dynamic> json = jsonDecode(configurationJson);

        value = json
            .whereType<Map<String, dynamic>>()
            .map((Map<String, dynamic> json) => HomeTabEntry.fromJson(json))
            .where((HomeTabEntry entry) => entry.valid)
            .toList();

        if (_defaultTabsCount != defaultHomeTabEntries.length) {
          throw Exception('invalid default tabs count: $_defaultTabsCount, '
              'expected ${defaultHomeTabEntries.length}');
        }

        log.fine('initialized home tab configuration');
      } catch (e, st) {
        log.warning('invalid configuration: $configurationJson', e, st);

        value = defaultHomeTabEntries;
      }
    }
  }

  /// Changes the ordering of the entries in the configuration.
  ///
  /// Only available for harpy pro.
  void reorder(int oldIndex, int newIndex) {
    log.fine('reordering from $oldIndex to $newIndex');

    final HomeTabEntry entry = value[oldIndex];

    final int index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    value = value
      ..removeAt(oldIndex)
      ..insert(index, entry);

    _persistValue();
  }

  /// Toggles the visibility of an entry in the configuration.
  ///
  /// Only available for harpy pro.
  void toggleVisible(int index) {
    log.fine('toggling visibility for $index');

    final HomeTabEntry entry = value[index];
    final List<HomeTabEntry> newValue = List<HomeTabEntry>.from(value);

    newValue[index] = entry.copyWith(
      visible: !entry.visible,
    );

    value = newValue;

    _persistValue();
  }

  /// Removes an entry from the configuration.
  ///
  /// Only has an effect if [HomeTabEntry.removable] returns `true` for the
  /// entry (e.g. when it's not a default entry that cannot be removed).
  void remove(int index) {
    if (value[index].removable) {
      value = List<HomeTabEntry>.from(value)..removeAt(index);
    }

    _persistValue();
  }

  /// Adds a twitter list as a home tab entry to the configuration.
  ///
  /// When [icon] is `null`, a random icon will be selected.
  ///
  /// Users of harpy free can only have one list at a time.
  /// Users of harpy pro can have up to 5 lists at a time.
  void addList({
    @required TwitterListData list,
    String icon,
  }) {
    if (Harpy.isFree && _listTabsCount > 0) {
      // can only add one list in harpy free (should be prevented in ui)
      assert(false, 'can only add one list in harpy free');
      return;
    } else if (_listTabsCount > 4) {
      // can only add up to 5 lists (should be prevented in ui)
      assert(false, 'can only add up to 5 lists');
      return;
    }

    // randomize the icon if it's null
    icon ??= (HomeTabEntryIcon.iconNameMap.keys.toList()..shuffle()).first;

    value = List<HomeTabEntry>.from(value)
      ..add(
        HomeTabEntry(
          id: list.idStr,
          type: HomeTabEntryType.list.value,
          icon: icon,
          name: list.name,
        ),
      );

    _persistValue();
  }

  /// Changes the icon of an entry in the configuration.
  ///
  /// Does nothing if [icon] is `null` or empty.
  void changeIcon(int index, String icon) {
    if (icon == null || icon.isEmpty) {
      // icon didn't change or user cancelled the icon change
      return;
    }

    value[index] = value[index].copyWith(icon: icon);
    value = List<HomeTabEntry>.from(value);

    _persistValue();
  }

  /// Returns the count of entries in the configuration where the type is a
  /// twitter list.
  int get _listTabsCount => value
      .where((HomeTabEntry entry) => entry.type == HomeTabEntryType.list.value)
      .length;

  /// Returns the count of entries in the configuration where the type is the
  /// default type.
  int get _defaultTabsCount => value
      .where((HomeTabEntry entry) =>
          entry.type == HomeTabEntryType.defaultType.value)
      .length;

  /// Encodes the configuration saves it into the preferences.
  void _persistValue() {
    try {
      homeTabPreferences.homeTabEntries = jsonEncode(
        value.map((HomeTabEntry entry) => entry.toJson()).toList(),
      );
    } catch (e, st) {
      // reset value?
      log.severe(
        'failed saving home tab configuration into preferences',
        e,
        st,
      );
    }
  }
}
