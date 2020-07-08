/// Pretty prints a duration difference as long as the difference is smaller
/// than an hour.
String prettyPrintDurationDifference(Duration difference) {
  final int minutes = difference.inMinutes;
  final int seconds = difference.inSeconds;

  if (minutes > 0) {
    final int remainingSeconds = seconds - minutes * 60;
    final String secondsString =
        remainingSeconds > 9 ? '$remainingSeconds' : '0$remainingSeconds';

    return '$minutes:$secondsString minutes';
  } else {
    return '$seconds seconds';
  }
}
