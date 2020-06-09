/// Splits the [list] into smaller lists with a max [length].
List<List<T>> splitList<T>(List<T> list, int length) {
  final List<List<T>> chunks = [];
  Iterable<T> chunk;

  do {
    final List<T> remainingEntries = list.sublist(
      chunks.length * length,
    );

    if (remainingEntries.isEmpty) {
      break;
    }

    chunk = remainingEntries.take(length);
    chunks.add(List<T>.from(chunk));
  } while (chunk.length == length);

  return chunks;
}
