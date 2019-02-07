import 'dart:io';

import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockDirectoryService extends Mock implements DirectoryService {}

class MockFile extends Mock implements File {}

void main() async {
  DirectoryService _directoryService;
  UserCache _userCache;

  setUp(() {
    _directoryService = MockDirectoryService();
    _userCache = UserCache(directoryService: _directoryService);
  });

  test(
      "check cache user will try to create file with correct name in correct bucket",
      () async {
    _userCache.cacheUser(User.mock()..id = 25);

    verify(
      _directoryService.createFile(
        bucket: argThat(
          equals("users/"),
          named: "bucket",
        ),
        name: argThat(
          equals("25.json"),
          named: "name",
        ),
        content: anyNamed("content"),
      ),
    );
  });

  test("check getCachedUser for existing", () {
    int userId = 123;
    when(
      _directoryService.getFile(
        bucket: anyNamed("bucket"),
        name: "123.json",
      ),
    ).thenAnswer((invoke) {
      File file = MockFile();

      when(
        file.readAsStringSync(),
      ).thenReturn(
        '{"id": ${userId}}',
      );
      return file;
    });

    User user = _userCache.getCachedUser(userId.toString());

    expect(user.id, userId);
  });

  test("check getCachedUser for not existing", () {
    int userId = 123;
    when(
      _directoryService.getFile(
        bucket: anyNamed("bucket"),
        name: "123.json",
      ),
    ).thenReturn(null);

    User user = _userCache.getCachedUser(userId.toString());

    expect(user, isNull);
  });
}
