import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/home/home_tab_customization/model/default_home_tab_entries.dart';
import 'package:harpy/core/core.dart';

class HomeTabModel extends ValueNotifier<List<HomeTabEntry>> {
  HomeTabModel() : super(<HomeTabEntry>[]) {
    _initialize();
  }

  final HomeTabPreferences homeTabPreferences = app<HomeTabPreferences>();

  void _initialize() {
    final String configurationJson = homeTabPreferences.homeTabEntries;

    if (configurationJson.isEmpty) {
      // no configuration exists
      value = defaultHomeTabEntries;
    } else {
      try {
        final List<Map<String, dynamic>> json = jsonDecode(configurationJson);

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

    // todo: persist value in storage
  }

  void toggleVisible(int index) {
    print('toggleVisible for $index');

    final HomeTabEntry entry = value[index];
    final List<HomeTabEntry> newValue = List<HomeTabEntry>.from(value);

    newValue[index] = entry.copyWith(
      visible: !entry.visible,
    );

    value = newValue;

    // todo: persist value in storage
  }
}
