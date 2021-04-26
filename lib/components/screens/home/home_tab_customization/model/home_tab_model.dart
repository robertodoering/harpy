import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/home/home_tab_customization/model/default_home_tab_entries.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';

// todo: instead of using a list as a value, use a custom object so that we
//  don't have to copy the list every time it changes
class HomeTabModel extends ValueNotifier<List<HomeTabEntry>> with HarpyLogger {
  HomeTabModel() : super(<HomeTabEntry>[]) {
    _initialize();
  }

  final HomeTabPreferences homeTabPreferences = app<HomeTabPreferences>();

  int get _listTabsCount => value
      .where((HomeTabEntry entry) => entry.type == HomeTabEntryType.list.value)
      .length;

  void _initialize() {
    final String configurationJson = homeTabPreferences.homeTabEntries;

    if (configurationJson.isEmpty) {
      // no configuration exists
      value = defaultHomeTabEntries;
    } else {
      try {
        final List<Map<String, dynamic>> json = jsonDecode(configurationJson);

        // todo: validate that all the default entries exist
        value = json
            .map((Map<String, dynamic> json) => HomeTabEntry.fromJson(json))
            .where((HomeTabEntry entry) => entry.valid)
            .toList();
      } catch (e) {
        // invalid configuration
        value = defaultHomeTabEntries;
      }
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final HomeTabEntry entry = value[oldIndex];

    final int index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    value = value
      ..removeAt(oldIndex)
      ..insert(index, entry);

    if (Harpy.isPro) {
      _persistValue();
    }
  }

  void toggleVisible(int index) {
    print('toggleVisible for $index');

    final HomeTabEntry entry = value[index];
    final List<HomeTabEntry> newValue = List<HomeTabEntry>.from(value);

    newValue[index] = entry.copyWith(
      visible: !entry.visible,
    );

    value = newValue;

    if (Harpy.isPro) {
      _persistValue();
    }
  }

  void remove(int index) {
    if (value[index].removable) {
      value = List<HomeTabEntry>.from(value)..removeAt(index);
    }

    _persistValue();
  }

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

    // todo: prevent adding the same list twice

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

  void changeIcon(int index, String icon) {
    if (icon == null) {
      // icon didn't change or user cancelled the icon change
      return;
    }

    value[index] = value[index].copyWith(icon: icon);
    value = List<HomeTabEntry>.from(value);

    _persistValue();
  }

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
