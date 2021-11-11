import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a card for the [user] that animates when scroll dowing with a
/// [ListCardAnimation].
class UserCard extends StatelessWidget {
  const UserCard(this.user);

  final UserData user;

  void _onUserTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context)!.settings,
      screenName: user.handle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListCardAnimation(
      key: ValueKey<int>(user.hashCode),
      child: HarpyListCard(
        color: theme.cardTheme.color,
        leading: HarpyCircleAvatar(
          imageUrl: user.profileImageUrl,
        ),
        title: Text(
          user.name,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${user.handle}',
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
            if (user.hasDescription) ...[
              defaultSmallVerticalSpacer,
              TwitterText(
                user.description!,
                entities: user.userDescriptionEntities,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                entityStyle: const TextStyle(),
                onHashtagTap: null,
                onUserMentionTap: null,
                onUrlTap: null,
              ),
            ],
            FollowersCount(user),
          ],
        ),
        onTap: () => _onUserTap(context),
      ),
    );
  }
}
