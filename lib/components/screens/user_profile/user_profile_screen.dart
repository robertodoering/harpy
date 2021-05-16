import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the screen for a user profile.
///
/// The [screenName] is used to load the user data upon creation.
// todo: refactor user profile screen & bloc
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    required this.screenName,
  });

  /// The screenName that is used to load the user data.
  final String? screenName;

  static const String route = 'user_profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileBloc>(
      create: (context) => UserProfileBloc(screenName: screenName),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          final bloc = UserProfileBloc.of(context);

          if (state is LoadingUserState) {
            return const UserProfileLoading();
          } else if (state is InitializedUserState ||
              state is TranslatingDescriptionState) {
            return FadeAnimation(
              duration: kShortAnimationDuration,
              curve: Curves.easeInOut,
              child: UserProfileContent(bloc: bloc),
            );
          } else {
            return FadeAnimation(
              duration: kShortAnimationDuration,
              curve: Curves.easeInOut,
              child: UserProfileError(bloc, screenName: screenName),
            );
          }
        },
      ),
    );
  }
}
