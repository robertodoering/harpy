import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the screen for a user profile.
///
/// The [screenName] is used to load the user data upon creation.
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
      create: (BuildContext context) => UserProfileBloc(screenName: screenName),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (BuildContext context, UserProfileState state) {
          final UserProfileBloc bloc = UserProfileBloc.of(context);

          Widget child;

          if (state is LoadingUserState) {
            child = const UserProfileLoading();
          } else if (state is InitializedUserState ||
              state is TranslatingDescriptionState) {
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
