import 'package:harpy/components/components.dart';

/// The default entries for the [HomeTabView] that determine the default
/// views in the home screen.
List<HomeTabEntry> defaultHomeTabEntries = <HomeTabEntry>[
  HomeTabEntry(
    id: 'home',
    type: HomeTabEntryType.defaultType.value,
    icon: 'home',
    name: 'timeline',
  ),
  HomeTabEntry(
    id: 'media',
    type: HomeTabEntryType.defaultType.value,
    icon: 'photo',
    name: 'media',
  ),
  HomeTabEntry(
    id: 'mentions',
    type: HomeTabEntryType.defaultType.value,
    icon: 'at',
    name: 'mentions',
  ),
  HomeTabEntry(
    id: 'search',
    type: HomeTabEntryType.defaultType.value,
    icon: 'search',
    name: 'search',
  ),
];
