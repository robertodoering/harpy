import 'dart:async';

import 'package:logging/logging.dart';

typedef Future<void> AsyncTask();

class AsyncInitializer {
  final Logger log = Logger("AsyncInitializer");

  final List<AsyncTask> tasks;
  final Completer<void> completer = Completer();

  AsyncInitializer(this.tasks);

  /// Calls all tasks at the same time and returns once every task has
  /// completed.
  Future<void> run() async {
    log.fine("async initialization started with ${tasks.length} tasks");

    for (AsyncTask task in tasks) {
      log.fine("task ${tasks.indexOf(task)} started");
      task()
          .then((_) => _onTaskFinished(task))
          .catchError((_) => _onTaskFinished(task));
    }

    return completer.future;
  }

  void _onTaskFinished(AsyncTask task) {
    tasks.remove(task);

    if (tasks.isEmpty) {
      log.fine("all tasks finished");
      completer.complete();
    }
  }
}
