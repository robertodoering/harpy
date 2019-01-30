import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/components/widgets/user_profile/user_profile_content.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/user_profile_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// The user profile screen to show information and the user timeline of the
/// [user].
///
/// If [user] is `null` [userId] mustn't be `null` and is used to load the
/// [User].
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    this.user,
    this.userId,
  }) : assert(user != null || userId != null);

  final User user;
  final String userId;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileModel userProfileModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);
    final loginModel = LoginModel.of(context);

    userProfileModel ??= UserProfileModel(
      user: widget.user,
      userId: widget.userId,
      userService: serviceProvider.data.userService,
      userCache: serviceProvider.data.userCache,
      loginModel: loginModel,
    );

    return ScopedModel<UserProfileModel>(
      model: userProfileModel,
      child: ScopedModelDescendant<UserProfileModel>(
        builder: (context, _, model) => UserProfileContent(),
      ),
    );
  }
}
