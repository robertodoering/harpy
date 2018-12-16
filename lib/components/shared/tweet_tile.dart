import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/screens/user_profile/user_profile_screen.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:harpy/components/shared/media/twitter_media.dart';
import 'package:harpy/components/shared/twitter_text.dart';
import 'package:harpy/core/utils/url_launcher.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/theme.dart';
import 'package:intl/intl.dart';

/// A single tile that display information and [TwitterButton]s for a [Tweet].
class TweetTile extends StatelessWidget {
  final Tweet tweet;

  const TweetTile({
    Key key,
    this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNameRow(context),
            SizedBox(height: 8.0),
            _buildText(),
            _buildMedia(),
            _buildActionRow(),
          ],
        ),
      ),
    );
  }

  String get displayTime {
    Duration timeDifference = DateTime.now().difference(tweet.createdAt);
    if (timeDifference.inHours <= 24) {
      return "${timeDifference.inHours}h";
    } else {
      return DateFormat("MMMd").format(tweet.createdAt);
    }
  }

  void _openUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(tweet.user),
      ),
    );
  }

  Widget _buildNameRow(BuildContext context) {
    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap: () => _openUserProfile(context),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              tweet.user.userProfileImageOriginal,
            ),
          ),
        ),

        SizedBox(width: 8.0),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // name
            Text(tweet.user.name),

            // username · time since tweet in hours
            Text(
              "@${tweet.user.screenName} \u00b7 $displayTime",
              style: HarpyTheme.theme.textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText() {
    return TwitterText(
      text: tweet.full_text,
      entities: tweet.entities,
      onEntityTap: (model) {
        if (model.type == EntityType.url) {
          launchUrl(model.url);
        }
      },
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        // retweet action
        TwitterButton(
          active: tweet.retweeted,
          inactiveIconData: Icons.repeat,
          activeIconData: Icons.repeat,
          value: tweet.retweetCount,
          color: Colors.green,
          activate: () => HomeStore.retweetTweet(tweet),
          deactivate: () => HomeStore.unretweetTweet(tweet),
        ),

        // favorite action
        TwitterButton(
          active: tweet.favorited,
          inactiveIconData: Icons.favorite_border,
          activeIconData: Icons.favorite,
          value: tweet.favoriteCount,
          color: Colors.red,
          activate: () => HomeStore.favoriteTweet(tweet),
          deactivate: () => HomeStore.unfavoriteTweet(tweet),
        ),
      ],
    );
  }

  Widget _buildMedia() {
    if (tweet.extended_entities?.media != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CollapsibleMedia(tweet.extended_entities.media),
      );
    } else {
      return Container();
    }
  }
}
