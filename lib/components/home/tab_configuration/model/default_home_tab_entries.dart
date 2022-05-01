import 'package:built_collection/built_collection.dart';
import 'package:harpy/components/components.dart';

/// The default entries for the that determine the default views in the home
/// page.
final defaultHomeTabEntries = [
  HomeTabEntry(
    id: 'home',
    type: HomeTabEntryType.defaultType,
    icon: 'home',
    name: 'timeline',
  ),
  HomeTabEntry(
    id: 'media',
    type: HomeTabEntryType.defaultType,
    icon: 'photo',
    name: 'media',
  ),
  HomeTabEntry(
    id: 'mentions',
    type: HomeTabEntryType.defaultType,
    icon: 'at',
    name: 'mentions',
  ),
  HomeTabEntry(
    id: 'search',
    type: HomeTabEntryType.defaultType,
    icon: 'search',
    name: 'search',
  ),
].toBuiltList();
