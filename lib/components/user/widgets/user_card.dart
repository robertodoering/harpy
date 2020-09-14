import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_tile_animation.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a card for the [user].
class UserCard extends StatelessWidget {
  const UserCard(this.user);

  final UserData user;

  void _onUserTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context).settings,
      screenName: user.screenName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TweetTileAnimation(
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          isThreeLine: user.hasDescription,
          leading: CachedCircleAvatar(
            imageUrl: user.profileImageUrlHttps,
          ),
          title: Text(user.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('@${user.screenName}'),
              if (user.hasDescription)
                TwitterText(
                  user.description,
                  entities: user.userDescriptionEntities,
                  entityColor: theme.accentColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          onTap: () => _onUserTap(context),
        ),
      ),
    );
  }
}
