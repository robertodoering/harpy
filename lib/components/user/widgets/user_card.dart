import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/list_card_animation.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/common/misc/twitter_text.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a card for the [user] that animates when scroll dowing with a
/// [ListCardAnimation].
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
    return ListCardAnimation(
      key: ValueKey<int>(user.hashCode),
      child: Card(
        child: ListTile(
          shape: kDefaultShapeBorder,
          isThreeLine: user.hasDescription,
          leading: CachedCircleAvatar(
            imageUrl: user.profileImageUrlHttps,
          ),
          title: Text(
            user.name,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '@${user.screenName}',
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              if (user.hasDescription)
                TwitterText(
                  user.description,
                  entities: user.userDescriptionEntities,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  entityStyle: const TextStyle(),
                  onHashtagTap: null,
                  onUserMentionTap: null,
                  onUrlTap: null,
                ),
            ],
          ),
          onTap: () => _onUserTap(context),
        ),
      ),
    );
  }
}
