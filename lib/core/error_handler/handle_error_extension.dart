typedef ErrorCallback = Function(dynamic error, StackTrace stackTrace);

extension HandleFutureError on Future<dynamic> {
  Future<R?> handleError<R>([ErrorCallback? onError]) async {
    try {
      return await this;
    } catch (e, st) {
      onError?.call(e, st);
      return null;
    }
  }
}
