import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/utils/file_utils.dart';

void main() {
  test("get valid file extension", () {
    const path = "/storage/emulated/0/Images/IMG-1337.jpg";

    final extension = getFileExtension(path);

    expect(extension, "jpg");
  });

  test("invalid file extension returns null", () {
    const path = "/storage/emulated/0/Images/IMG-1337";

    final extension = getFileExtension(path);

    expect(extension, null);
  });
}
