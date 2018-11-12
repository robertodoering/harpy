import 'package:harpy/api/twitter/data/user.dart';

abstract class UserService {
  Future<List<User>> getUsersByIds(List<String> ids);
  Future<User> getUserById(String ids);
}
