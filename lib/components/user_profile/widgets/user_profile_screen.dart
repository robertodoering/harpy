import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_content.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_error.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_loading.dart';

/// Builds the screen for a user profile.
///
/// The [screenName] is used to load the user data upon creation.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    @required this.screenName,
  });

  /// The screenName that is used to load the user data.
  final String screenName;

  static const String route = 'user_profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileBloc>(
      create: (BuildContext context) => UserProfileBloc(screenName: screenName),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (BuildContext context, UserProfileState state) {
          final UserProfileBloc bloc = UserProfileBloc.of(context);

          Widget child;

          if (state is LoadingUserState) {
            child = const UserProfileLoading();
          } else if (state is InitializedUserState) {
            child = UserProfileContent(bloc: bloc);
          } else {
            child = UserProfileError(bloc, screenName: screenName);
          }

          return AnimatedSwitcher(
            duration: kShortAnimationDuration,
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: child,
          );
        },
      ),
    );
  }
}
