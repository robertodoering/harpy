import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_content.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/user_profile_model.dart';
import 'package:provider/provider.dart';

/// The user profile screen to show information and the user timeline of the
/// [user].
///
/// If [user] is `null` [userId] mustn't be `null` and is used to load the
/// [User].
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    this.user,
    this.userId,
  }) : assert(user != null || userId != null);

  static const route = "user";

  final User user;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileModel>(
      create: (_) => UserProfileModel(
        user: user,
        userId: userId,
        loginModel: LoginModel.of(context),
      ),
      child: UserProfileContent(),
    );
  }
}
