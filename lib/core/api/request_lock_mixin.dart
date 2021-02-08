/// A lock for requests to prevent successive calls for a given duration.
mixin RequestLock {
  bool _isLocked = false;
  bool get isLocked => _isLocked;

  /// Sets [_isLocked] to `true` for the given [duration] if it is `false`.
  ///
  /// Returns `false` if [_isLocked] was `false` before.
  /// Returns `true` if it was already locked.
  bool lock({
    Duration duration = const Duration(seconds: 5),
  })  {
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
