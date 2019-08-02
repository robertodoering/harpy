import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/user_database.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';

class MockStore extends Mock implements StoreRef<int, Map<String, dynamic>> {}

class MockRecord extends Mock implements RecordRef<int, Map<String, dynamic>> {}

class MockRecordSnapshot extends Mock
    implements RecordSnapshot<int, Map<String, dynamic>> {}

void main() {
  test("Finds and decodes user", () async {
    final store = MockStore();
    final mockRecordSnapshot = MockRecordSnapshot();

    final database = UserDatabase(store: store);

    final user = User()..id = 1337;

    when(store.findFirst(
      any,
      finder: anyNamed("finder"),
    )).thenAnswer((_) => Future.value(mockRecordSnapshot));

    when(mockRecordSnapshot.value).thenReturn(toPrimitiveJson(user.toJson()));

    final User foundUser = await database.findUser(1337);

    expect(foundUser, user);
  });
}
