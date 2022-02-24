extension StringListExtension on List<String> {
  List<String> copySafeAdd(String? value) =>
      value != null && value.isNotEmpty ? [...this, value] : this;

  List<String> copySafeRemoveAt(int index) {
    return index >= 0 && index < length ? ([...this]..removeAt(index)) : this;
  }
}

/// Splits the [list] into smaller lists with a max [length].
List<List<T>> splitList<T>(List<T> list, int length) {
  final chunks = <List<T>>[];
  Iterable<T> chunk;

  do {
    final remainingEntries = list.sublist(chunks.length * length);

    if (remainingEntries.isEmpty) break;

    chunk = remainingEntries.take(length);
    chunks.add(List<T>.from(chunk));
  } while (chunk.length == length);

  return chunks;
}
