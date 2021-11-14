import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// The header for the [HomeDrawer].
class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader();

  Widget _buildAvatarRow(BuildContext context, UserData user) {
    return GestureDetector(
      onTap: () => app<HarpyNavigator>().pushUserProfile(initialUser: user),
      child: Row(
        children: [
          // circle avatar
          HarpyCircleAvatar(
            radius: 32,
            imageUrl: user.appropriateUserImageUrl,
          ),

          const SizedBox(width: 16),

          // name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.handle}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final user = authCubit.state.user;

    if (user == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top, // + statusbar height
        16,
        8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarRow(context, user),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FollowersCount(user),
          ),
        ],
      ),
    );
  }
}
