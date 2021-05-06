typedef ErrorCallback = Function(dynamic error, StackTrace stackTrace);

extension HandleFutureError<R> on Future<R> {
  Future<R?> handleError([ErrorCallback? onError]) async {
    try {
      return await this;
    } catch (e, st) {
      onError?.call(e, st);
      return null;
    }
  }
}
