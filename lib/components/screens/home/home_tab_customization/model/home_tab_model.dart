import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';

class HomeTabModel extends ValueNotifier<HomeTabConfiguration>
    with HarpyLogger {
  HomeTabModel() : super(HomeTabConfiguration.empty) {
    _initialize();
  }

  final HomeTabPreferences homeTabPreferences = app<HomeTabPreferences>();

  void _initialize() {
    final String configurationJson = homeTabPreferences.homeTabConfiguration;

    if (configurationJson.isEmpty) {
      log.fine('no configuration exists');

      value = HomeTabConfiguration.defaultConfiguration;
    } else {
      try {
        value = HomeTabConfiguration.fromJson(jsonDecode(configurationJson));

        if (value.defaultTabsCount != defaultHomeTabEntries.length) {
          throw Exception('invalid default tabs count: '
              '${value.defaultTabsCount}, '
              'expected ${defaultHomeTabEntries.length}');
        }

        log.fine('initialized home tab configuration');
      } catch (e, st) {
        log.warning('invalid configuration: $configurationJson', e, st);

        value = HomeTabConfiguration.empty;
      }
    }
  }

  /// Changes the ordering of the entries in the configuration.
  ///
  /// Only available for harpy pro.
  void reorder(int oldIndex, int newIndex) {
    log.fine('reordering from $oldIndex to $newIndex');

    final HomeTabEntry entry = value.entries[oldIndex];
    final int index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    value = value.removeEntry(oldIndex).addEntry(entry, index);

    _persistValue();
  }

  /// Toggles the visibility of an entry in the configuration.
  ///
  /// Only available for harpy pro.
  void toggleVisible(int index) {
    log.fine('toggling visibility for $index');

    final HomeTabEntry entry = value.entries[index];

    value = value.updateEntry(
      index,
      entry.copyWith(visible: !entry.visible),
    );

    _persistValue();
  }

  /// Removes an entry from the configuration.
  ///
  /// Only has an effect if [HomeTabEntry.removable] returns `true` for the
  /// entry (e.g. when it's not a default entry that cannot be removed).
  void remove(int index) {
    if (value.entries[index].removable) {
      value = value.removeEntry(index);
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
    if (Harpy.isFree && value.listTabsCount > 0) {
      // can only add one list in harpy free (should be prevented in ui)
      assert(false, 'can only add one list in harpy free');
      return;
    } else if (value.listTabsCount > 4) {
      // can only add up to 5 lists (should be prevented in ui)
      assert(false, 'can only add up to 5 lists');
      return;
    }

    // randomize the icon if it's null
    icon ??= (HomeTabEntryIcon.iconNameMap.keys.toList()..shuffle()).first;

    value = value.addEntry(
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

    value = value.updateEntry(
      index,
      value.entries[index].copyWith(icon: icon),
    );

    _persistValue();
  }

  /// Encodes the configuration saves it into the preferences.
  void _persistValue() {
    try {
      homeTabPreferences.homeTabConfiguration = jsonEncode(value.toJson());
    } catch (e, st) {
      value = HomeTabConfiguration.defaultConfiguration;
      log.severe(
        'failed saving home tab configuration into preferences',
        e,
        st,
      );
    }
  }
}
