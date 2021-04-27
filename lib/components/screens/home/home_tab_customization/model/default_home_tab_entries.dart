import 'package:harpy/components/components.dart';

/// The default entries for the [HomeTabView] that is used when no
/// customization has taken place yet.
List<HomeTabEntry> defaultHomeTabEntries = <HomeTabEntry>[
  HomeTabEntry(
    id: 'home',
    type: HomeTabEntryType.defaultType.value,
    icon: 'home',
    name: 'timeline',
    visible: true,
  ),
  HomeTabEntry(
    id: 'media',
    type: HomeTabEntryType.defaultType.value,
    icon: 'media',
    name: 'media',
    visible: true,
  ),
  HomeTabEntry(
    id: 'mentions',
    type: HomeTabEntryType.defaultType.value,
    icon: 'mentions',
    name: 'mentions',
    visible: true,
  ),
  HomeTabEntry(
    id: 'search',
    type: HomeTabEntryType.defaultType.value,
    icon: 'search',
    name: 'search',
    visible: true,
  ),
];
