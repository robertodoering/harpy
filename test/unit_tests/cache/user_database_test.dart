import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/database_service.dart';
import 'package:harpy/core/cache/user_database.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  setUp(() {
    app..registerLazySingleton<DatabaseService>(() => MockDatabaseService());
  });

  tearDown(app.reset);

  test("Finds and decodes user", () async {
    final database = UserDatabase();

    final user = User()..id = 1337;
    final userJson = toPrimitiveJson(user.toJson());

    final bool result = await database.recordUser(user);

    expect(result, true);

    verify(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: anyNamed("store"),
      key: user.id,
      data: userJson,
    ));
  });

  test("Exception during user record fails gracefully and returns false",
      () async {
    final database = UserDatabase();

    final user = User()..id = 1337;
    final userJson = toPrimitiveJson(user.toJson());

    when(app<DatabaseService>().record(
      path: anyNamed("path"),
      store: anyNamed("store"),
      key: user.id,
      data: userJson,
    )).thenThrow(Exception("Test exception"));

    final bool result = await database.recordUser(user);

    expect(result, false);
  });

  test("Finds and decodes user from id", () async {
    final database = UserDatabase();

    final user = User()..id = 1337;
    final userJson = toPrimitiveJson(user.toJson());

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(userJson));

    final foundUser = await database.findUser(user.id);

    expect(foundUser, user);
  });

  test("Returns null if user json can't be found", () async {
    final database = UserDatabase();

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(null));

    final foundUser = await database.findUser(1337);

    expect(foundUser, null);
  });

  test("Returns null if finding user throws exception", () async {
    final database = UserDatabase();

    final user = User()..id = 1337;

    when(app<DatabaseService>().findFirst(
      path: anyNamed("path"),
      store: anyNamed("store"),
      finder: anyNamed("finder"),
    )).thenThrow(Exception("Test exception"));

    final foundUser = await database.findUser(user.id);

    expect(foundUser, null);
  });
}
