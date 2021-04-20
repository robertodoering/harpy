import 'package:harpy/components/components.dart';

/// The default entries for the [HomeTabView] that is used when no
/// customization has taken place yet.
List<HomeTabEntry> defaultHomeTabEntries = <HomeTabEntry>[
  const HomeTabEntry(
    id: 'home',
    type: 'default',
    icon: 'home',
    name: 'timeline',
    visible: true,
  ),
  const HomeTabEntry(
    id: 'media',
    type: 'default',
    icon: 'media',
    name: 'media',
    visible: true,
  ),
  const HomeTabEntry(
    id: 'mentions',
    type: 'default',
    icon: '@',
    name: 'mentions',
    visible: true,
  ),
  const HomeTabEntry(
    id: 'search',
    type: 'default',
    icon: 'search',
    name: 'search',
    visible: true,
  ),
];
