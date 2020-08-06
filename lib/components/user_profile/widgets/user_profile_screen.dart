import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/harpy_background.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_content.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_error.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_loading.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Builds the screen for a user profile.
///
/// The [user] is used to display the user data if not `null`.
/// Otherwise the [screenName] is used to load the user data upon creation.
///
/// Either [user] or [screenName] must not be `null`.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    this.user,
    this.screenName,
  }) : assert(user != null || screenName != null);

  /// The user to display.
  final UserData user;

  /// The screenName that is used to load the user data.
  final String screenName;

  static const String route = 'user_profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileBloc>(
      create: (BuildContext context) => UserProfileBloc(
        user: user,
        screenName: screenName,
      ),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (BuildContext context, UserProfileState state) {
          final UserProfileBloc bloc = UserProfileBloc.of(context);

          Widget child;

          if (state is LoadingUserState) {
            child = const UserProfileLoading();
          } else if (state is InitializedUserState) {
            child = UserProfileContent(bloc);
          } else {
            child = UserProfileError(bloc, user: user, screenName: screenName);
          }

          return HarpyBackground(
            child: AnimatedSwitcher(
              duration: kShortAnimationDuration,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
