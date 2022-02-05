/// Appends [value] to a copy of [list] if [value] is not `null` or empty and
/// returns it.
///
/// Returns the [list] if [value] is `null` or empty.
List<String> appendToList(List<String> list, String? value) {
  if (value != null && value.isNotEmpty) {
    return List<String>.of(list)..add(value);
  } else {
    return list;
  }
}

/// Removes the [index] from the [list] and returns it.
///
/// Returns the [list] if [index] is is out of bounds of the [list] or if the
/// [list] is `null`.
List<String> removeFromList(List<String> list, int index) {
  final updatedList = List<String>.of(list);

  if (index >= 0 && index < updatedList.length) {
    return updatedList..removeAt(index);
  } else {
    return list;
  }
}

/// Splits the [list] into smaller lists with a max [length].
List<List<T>> splitList<T>(List<T> list, int length) {
  final chunks = <List<T>>[];
  Iterable<T> chunk;

  do {
    final remainingEntries = list.sublist(
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
