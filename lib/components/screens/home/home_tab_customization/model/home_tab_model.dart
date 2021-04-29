import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';

class HomeTabModel extends ValueNotifier<HomeTabConfiguration>
    with HarpyLogger {
  HomeTabModel() : super(HomeTabConfiguration.empty) {
    initialize();
  }

  final HomeTabPreferences homeTabPreferences = app<HomeTabPreferences>();

  List<HomeTabEntry> get visibleEntries =>
      value.entries.where((HomeTabEntry entry) => entry.visible).toList();

  List<HomeTabEntry> get listEntries => value.entries
      .where((HomeTabEntry entry) => entry.type == HomeTabEntryType.list.value)
      .toList();

  /// The amount of tabs that are not hidden.
  int get visibleTabsCount => visibleEntries.length;

  bool get canHideMoreEntries => visibleEntries.length > 1;

  /// Whether the user can add more lists.
  ///
  /// In the free version, only one list can be added.
  /// In the pro version, up to 10 lists can be added.
  bool get canAddMoreLists =>
      Harpy.isFree && listTabsCount == 0 || Harpy.isPro && listTabsCount < 10;

  /// Returns the count of entries in the configuration where the type is a
  /// twitter list.
  int get listTabsCount => value.entries
      .where((HomeTabEntry entry) => entry.type == HomeTabEntryType.list.value)
      .length;

  /// Returns the count of entries in the configuration where the type is the
  /// default type.
  int get defaultTabsCount => value.entries
      .where((HomeTabEntry entry) =>
          entry.type == HomeTabEntryType.defaultType.value)
      .length;

  void initialize() {
    final String configurationJson = homeTabPreferences.homeTabConfiguration;

    if (configurationJson.isEmpty) {
      log.fine('no configuration exists');

      value = HomeTabConfiguration.defaultConfiguration;
    } else {
      try {
        value = HomeTabConfiguration.fromJson(jsonDecode(configurationJson));

        if (defaultTabsCount != defaultHomeTabEntries.length) {
          throw Exception('invalid default tabs count: $defaultTabsCount, '
              'expected ${defaultHomeTabEntries.length}');
        } else if (value.entries.any((HomeTabEntry entry) => !entry.valid)) {
          throw Exception('invalid entry in configuration');
        }

        log.fine('initialized home tab configuration');
      } catch (e, st) {
        log.warning('invalid configuration: $configurationJson', e, st);

        value = HomeTabConfiguration.defaultConfiguration;
      }
    }
  }

  void setToDefault() {
    value = HomeTabConfiguration.defaultConfiguration;
    _persistValue();
  }

  /// Changes the ordering of the entries in the configuration.
  ///
  /// Only available for harpy pro.
  void reorder(int oldIndex, int newIndex) {
    log.fine('reordering from $oldIndex to $newIndex');

    final HomeTabEntry entry = value.entries[oldIndex];
    final int index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    value = value.removeEntry(oldIndex).addEntry(entry, index);

    if (Harpy.isPro) {
      _persistValue();
    }
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

    if (Harpy.isPro) {
      _persistValue();
    }
  }

  /// Removes an entry from the configuration.
  ///
  /// Only has an effect if [HomeTabEntry.removable] returns `true` for the
  /// entry (e.g. when it's not a default entry that cannot be removed).
  void remove(int index) {
    if (Harpy.isFree) {
      // reset to default configuration
      value = HomeTabConfiguration.defaultConfiguration;
    } else if (value.entries[index].removable) {
      value = value.removeEntry(index);
    }

    _persistValue();
  }

  /// Adds a twitter list as a home tab entry to the configuration.
  ///
  /// When [icon] is `null`, a random icon will be selected.
  ///
  /// Users of harpy free can only have one list at a time.
  /// Users of harpy pro can have up to 10 lists at a time.
  void addList({
    @required TwitterListData list,
    String icon,
  }) {
    if (!canAddMoreLists) {
      return;
    }

    if (Harpy.isFree) {
      // reset to default configuration before adding list
      value = HomeTabConfiguration.defaultConfiguration;
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

    final HomeTabEntry entry = value.entries[index];

    value = value.updateEntry(
      index,
      entry.copyWith(icon: icon),
    );

    if (Harpy.isPro ||
        Harpy.isFree && entry.type == HomeTabEntryType.list.value) {
      _persistValue();
    }
  }

  /// Changes the name of an entry in the configuration.
  void changeName(int index, String name) {
    value = value.updateEntry(
      index,
      value.entries[index].copyWith(name: name),
    );

    if (Harpy.isPro) {
      _persistValue();
    }
  }

  /// Encodes the configuration and saves it into the preferences.
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
