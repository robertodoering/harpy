import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/utils/list_utils.dart';

void main() {
  test("list splits into multiple chunks with remaining values", () {
    const List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    final List<List<int>> chunks = splitList<int>(list, 5);

    const List<List<int>> expected = [
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10],
      [11, 12],
    ];

    expect(chunks, expected);
  });

  test("list splits into one chunk", () {
    const List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    final List<List<int>> chunks = splitList<int>(list, 20);

    const List<List<int>> expected = [
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    ];

    expect(chunks, expected);
  });

  test("list splits into multiple chunks without remaining values", () {
    const List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    final List<List<int>> chunks = splitList<int>(list, 6);

    const List<List<int>> expected = [
      [1, 2, 3, 4, 5, 6],
      [7, 8, 9, 10, 11, 12],
    ];

    expect(chunks, expected);
  });
}
