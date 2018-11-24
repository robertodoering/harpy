import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:harpy/api/twitter/services/user/user_service.dart';
import 'package:harpy/core/json/json_mapper.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:meta/meta.dart';

class UserServiceImpl extends TwitterService
    with JsonMapper<User>
    implements UserService {
  Future getUserDetails({@required String id}) async {
    var response = await client.get(
      "https://api.twitter.com/1.1/users/show.json",
      params: {"user_id": id, "include_entities": "true"},
    );

    return handleResponse(response, onSuccess: (response) {
      return map((map) => User.fromJson(map), response.body);
    });
  }

  @override
  Future<User> getUserById(String ids) async {
    try {
      List<User> users = await getUsersByIds([ids]);
      return users[0];
    } catch (ex) {
      return Future.error(ex);
    }
  }

  @override
  Future<List<User>> getUsersByIds(List<String> ids) async {
    var response = await client.get(
        "https://api.twitter.com/1.1/users/lookup.json?user_id=${explodeListToSeparatedString(ids)}");

    if (response.statusCode == 200) {
      List<User> users = map((map) {
        return User.fromJson(map);
      }, response.body);
      return Future<List<User>>(() => users);
    } else {
      return Future.error(response.body);
    }
  }
}
