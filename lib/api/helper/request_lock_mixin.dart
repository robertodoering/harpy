/// A lock for requests to prevent successive calls for a given duration.
///
/// Used to prevent spamming a request when the request is triggered
/// automatically (e.g. when scrolling at the end of a list to load more
/// paginated data).
mixin RequestLock {
  bool _isLocked = false;
  bool get isLocked => _isLocked;

  /// Sets [_isLocked] to `true` for the given [duration] if it is `false`.
  ///
  /// Returns `false` if [_isLocked] was `false` before.
  /// Returns `true` if it was already locked.
  bool lock({
    Duration duration = const Duration(seconds: 1),
  }) {
    if (!_isLocked) {
      _isLocked = true;
      Future<void>.delayed(duration).then((_) {
        _isLocked = false;
      });

      return false;
    } else {
      return true;
    }
  }
}
