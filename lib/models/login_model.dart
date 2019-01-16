import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModel extends Model {
  static LoginModel of(BuildContext context) {
    return ScopedModel.of<LoginModel>(context);
  }

  bool loggingIn = false;

  Future<void> login() async {
//    TwitterLoginResult result =
//        await AppConfiguration().twitterLogin.authorize();

    await Future.delayed(Duration(seconds: 2));
  }
}
