import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/fading_nested_scaffold.dart';
import 'package:harpy/components/common/harpy_scaffold.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/components/user_profile/widgets/user_profile_header.dart';
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

  Widget _buildLoading() {
    return const HarpyScaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(ThemeData theme, UserProfileBloc bloc) {
    return HarpyScaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Error loading user',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            HarpyButton.flat(
              dense: true,
              text: 'retry',
              onTap: () => bloc.add(InitializeUserEvent(
                user: user,
                screenName: screenName,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserProfileBloc bloc) {
    return FadingNestedScaffold(
      title: bloc.user.name,
      background: GestureDetector(
        // todo: open image gallery
        onTap: () {},
        child: CachedNetworkImage(
          imageUrl: bloc.user.profileBannerUrl,
          fit: BoxFit.cover,
        ),
      ),
      body: UserProfileHeader(bloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider<UserProfileBloc>(
      create: (BuildContext context) => UserProfileBloc(
        user: user,
        screenName: screenName,
      ),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (BuildContext context, UserProfileState state) {
          final UserProfileBloc bloc = UserProfileBloc.of(context);
          if (state is LoadingUserState) {
            return _buildLoading();
          } else if (state is InitializedUserState) {
            return _buildUserProfile(bloc);
          } else {
            return _buildError(theme, bloc);
          }
        },
      ),
    );
  }
}
