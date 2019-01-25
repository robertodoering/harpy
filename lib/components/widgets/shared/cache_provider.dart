import 'package:flutter/material.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';

/// Provides the [HomeTimelineCache] and [UserTimelineCache] instances.
class CacheProvider extends InheritedWidget {
  const CacheProvider({
    @required Widget child,
    @required this.homeTimelineCache,
    this.userTimelineCache,
  })  : assert(homeTimelineCache != null),
        super(child: child);

  final HomeTimelineCache homeTimelineCache;
  final UserTimelineCache userTimelineCache;

  static CacheProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CacheProvider) as CacheProvider;
  }

  @override
  bool updateShouldNotify(CacheProvider old) {
    return false;
  }
}
