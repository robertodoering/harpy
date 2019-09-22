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
  final _tweetDatabase = app<TweetDatabase>();
  final _userDatabase = app<UserDatabase>();
  final _timelineDatabase = app<TimelineDatabase>();

  final _flushbarService = app<FlushbarService>();

  bool _clearing = false;

  Future<void> _clear() async {
    setState(() {
      _clearing = true;
    });

    final List<bool> results = await Future.wait<bool>([
      _tweetDatabase.drop(),
      _userDatabase.drop(),
      _timelineDatabase.drop(),
    ]);

    if (results.any((result) => result)) {
      _flushbarService.info("Cache cleared");
    } else {
      _flushbarService.info("Nothing to clear");
    }

    setState(() {
      _clearing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete),
      trailing: _clearing ? const CircularProgressIndicator() : null,
      title: const Text("Clear cache"),
      subtitle: const Text("Delete all cached data"),
      onTap: _clearing ? null : _clear,
    );
  }
}
