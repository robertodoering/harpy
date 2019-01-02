import 'dart:async';

typedef Future<void> AsyncTask();

class AsyncInitializer {
  final List<AsyncTask> tasks;
  final Completer<void> c = Completer();

  AsyncInitializer(this.tasks);

  /// Calls all tasks at the same time and returns once every task has
  /// completed.
  Future<void> run() async {
    print("initialize");
    for (AsyncTask task in tasks) {
      print("task ${tasks.indexOf(task)} started");
      task().then((_) => _onTaskFinished(task)); // todo: error handling
    }

    return c.future;
  }

  void _onTaskFinished(AsyncTask task) {
    tasks.remove(task);

    if (tasks.isEmpty) {
      print("last task finished");
      c.complete();
    }
  }
}
