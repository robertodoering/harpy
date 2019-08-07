import 'package:flutter/material.dart';
import 'package:harpy/core/cache/timeline_database.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/core/cache/user_database.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/harpy.dart';

/// A [ListTile] that clears the cache and shows a flushbar if it has been
/// cleared.
class ClearCacheListTile extends StatefulWidget {
  @override
  _ClearCacheListTileState createState() => _ClearCacheListTileState();
}

class _ClearCacheListTileState extends State<ClearCacheListTile> {
  bool _clearing = false;

  Future<void> _clear() async {
    setState(() {
      _clearing = true;
    });

    final List<bool> results = await Future.wait<bool>([
      app<TweetDatabase>().drop(),
      app<UserDatabase>().drop(),
      app<TimelineDatabase>().drop(),
    ]);

    if (results.any((result) => result)) {
      app<FlushbarService>().info("Cache cleared");
    } else {
      app<FlushbarService>().info("Nothing to clear");
    }

    setState(() {
      _clearing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.cloud_off),
      trailing: _clearing ? const CircularProgressIndicator() : null,
      title: const Text("Clear cache"),
      subtitle: const Text("Delete all cached data"),
      onTap: _clearing ? null : _clear,
    );
  }
}
