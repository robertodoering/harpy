import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/user_profile/user_profile_screen.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:harpy/components/shared/media/twitter_media.dart';
import 'package:harpy/components/shared/twitter_text.dart';
import 'package:harpy/components/shared/util.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/core/utils/url_launcher.dart';
import 'package:harpy/stores/home_store.dart';

/// A single tile that display information and [TwitterActionButton]s for a [Tweet].
class TweetTile extends StatefulWidget {
  final Tweet tweet;
  final User retweetUser;

  /// Determines whether or not to open the user profile on avatar / name tap.
  final bool openUserProfile;

  TweetTile({
    Key key,
    Tweet tweet,
    this.openUserProfile = true,
  })  : tweet = tweet.retweetedStatus != null ? tweet.retweetedStatus : tweet,
        retweetUser = tweet.retweetedStatus != null ? tweet.user : null,
        super(key: key);

  @override
  TweetTileState createState() => TweetTileState();
}

class TweetTileState extends State<TweetTile> {
  bool _translating = false;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRetweetedRow(),
            _buildNameRow(context),
            _buildText(),
            _buildTranslation(context),
            _buildMedia(),
            _buildActionRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRetweetedRow() {
    return widget.retweetUser == null
        ? Container()
        : Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                IconRow(
                  icon: Icons.repeat,
                  iconPadding: 40.0, // same as avatar width
                  child: "${widget.retweetUser.name} retweeted",
                ),
              ],
            ),
          );
  }

  Widget _buildNameRow(BuildContext context) {
    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap:
              widget.openUserProfile ? () => _openUserProfile(context) : null,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              widget.tweet.user.userProfileImageOriginal,
            ),
          ),
        ),

        SizedBox(width: 8.0),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // name
            Text(widget.tweet.user.name),

            // username · time since tweet in hours
            Text(
              "@${widget.tweet.user.screenName} \u00b7 ${tweetTimeDifference(widget.tweet.createdAt)}",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText() {
    return !widget.tweet.emptyText
        ? Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TwitterText(
              text: widget.tweet.full_text,
              entities: widget.tweet.entities,
              onEntityTap: (model) {
                if (model.type == EntityType.url) {
                  launchUrl(model.url);
                }
              },
            ),
          )
        : Container();
  }

  Widget _buildTranslation(BuildContext context) {
    if (_translating) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.tweet.harpyData.translation == null ||
        widget.tweet.harpyData.translation.unchanged) {
      return Container();
    }

    // todo: expand into existence
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Text(
              "Translated from ",
              style: Theme.of(context).textTheme.display1,
            ),
            Text(widget.tweet.harpyData.translation
                .language), // todo: check if not null
          ],
        ),
        SizedBox(height: 4.0),
        TwitterText(
          text: widget.tweet.harpyData.translation.text,
          entities: widget.tweet.entities,
        ),
      ],
    );
  }

  Widget _buildMedia() {
    return widget.tweet.extended_entities?.media != null
        ? CollapsibleMedia(tweet: widget.tweet)
        : Container();
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: <Widget>[
        // retweet action
        TwitterActionButton(
          active: widget.tweet.retweeted,
          inactiveIcon: Icons.repeat,
          activeIcon: Icons.repeat,
          text: "${formatNumber(widget.tweet.retweetCount)}",
          color: Colors.green,
          activate: () => HomeStore.retweetTweet(widget.tweet),
          deactivate: () => HomeStore.unretweetTweet(widget.tweet),
        ),

        // favorite action
        TwitterActionButton(
          active: widget.tweet.favorited,
          inactiveIcon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          text: "${formatNumber(widget.tweet.favoriteCount)}",
          color: Colors.red,
          activate: () => HomeStore.favoriteTweet(widget.tweet),
          deactivate: () => HomeStore.unfavoriteTweet(widget.tweet),
        ),

        Expanded(child: Container()),

        _buildTranslationButton(context),
      ],
    );
  }

  Widget _buildTranslationButton(BuildContext context) {
    if (widget.tweet.emptyText || widget.tweet.lang == "en") {
      return Container();
    }

    VoidCallback onPressed;
    bool drawColorOnHighlight = false;
    Color color = Colors.blue;

    if (widget.tweet.harpyData.translation == null && !_translating) {
      drawColorOnHighlight = true;

      onPressed = () async {
        setState(() {
          _translating = true;
        });

        await HomeStore.translateTweet(widget.tweet);

        setState(() {
          _translating = false;
        });

        if (widget.tweet.harpyData.translation.unchanged) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Tweet not translated"),
          ));
        }
      };
    } else if (widget.tweet.harpyData?.translation?.unchanged ?? false) {
      color = Theme.of(context).disabledColor;
    }

    return HarpyButton(
      icon: Icons.translate,
      onPressed: onPressed,
      iconColor: color,
      splashColor: color,
      drawColorOnHighlight: drawColorOnHighlight,
    );
  }

  void _openUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(widget.tweet.user),
      ),
    );
  }
}
