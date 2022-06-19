/// Signature for a function that is called when an exception has been caught.
typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);

extension HandleFutureError<R> on Future<R> {
  /// Extension on a future that will return the result of the future, or `null`
  /// if an exception ocurred.
  Future<R?> handleError([ErrorCallback? onError]) async {
    try {
      return await this;
    } catch (e, st) {
      onError?.call(e, st);
      return null;
    }
  }
}
