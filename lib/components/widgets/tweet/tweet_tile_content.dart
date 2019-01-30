import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/screens/user_profile_screen.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/components/widgets/shared/twitter_text.dart';
import 'package:harpy/components/widgets/tweet/collapsible_tweet_media.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_quote.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/models/tweet_model.dart';

class TweetTileContent extends StatefulWidget {
  @override
  _TweetTileContentState createState() => _TweetTileContentState();
}

class _TweetTileContentState extends State<TweetTileContent>
    with SingleTickerProviderStateMixin<TweetTileContent> {
  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TweetRetweetedRow(model),
        _TweetAvatarNameRow(model),
        TweetText(model),
        TweetQuote(model),
        AnimatedSize(
          vsync: this,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
          child: _TweetTranslation(model),
        ),
        _TweetMedia(model),
        _TweetActionsRow(model),
      ],
    );
  }
}

/// If the [Tweet] is a retweet this builds information of the person that
/// retweeted this [Tweet].
class _TweetRetweetedRow extends StatelessWidget {
  const _TweetRetweetedRow(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (model.isRetweet) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: IconRow(
          icon: Icons.repeat,
          iconPadding: 40.0, // same as avatar width
          child: "${model.originalTweet.user.name} retweeted",
        ),
      );
    } else {
      return Container();
    }
  }
}

/// Builds the [Tweet] avatar next to the [TweetNameColumn].
class _TweetAvatarNameRow extends StatelessWidget {
  const _TweetAvatarNameRow(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap: () {
            HarpyNavigator.push(
              context,
              UserProfileScreen(user: model.tweet.user),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              model.tweet.user.userProfileImageOriginal,
            ),
          ),
        ),

        SizedBox(width: 8.0),

        TweetNameColumn(model),
      ],
    );
  }
}

/// Builds the name with the username and the time since tweet in hours.
class TweetNameColumn extends StatelessWidget {
  const TweetNameColumn(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // name
        GestureDetector(
          onTap: () {
            HarpyNavigator.push(
              context,
              UserProfileScreen(user: model.tweet.user),
            );
          },
          child: Text(model.tweet.user.name),
        ),

        // username · time since tweet in hours
        GestureDetector(
          onTap: () {
            HarpyNavigator.push(
              context,
              UserProfileScreen(user: model.tweet.user),
            );
          },
          child: Text(
            model.screenNameAndTime,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}

/// Builds the text of the [Tweet].
class TweetText extends StatelessWidget {
  const TweetText(this.model);

  final TweetModel model;

  void _onEntityTap(BuildContext context, TwitterEntityModel entityModel) {
    if (entityModel.type == EntityType.url) {
      launchUrl(entityModel.data);
    } else if (entityModel.type == EntityType.mention) {
      HarpyNavigator.push(context, UserProfileScreen(userId: entityModel.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!model.tweet.emptyText) {
      return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: TwitterText(
          text: model.tweet.full_text,
          entities: model.tweet.entities,
          onEntityTap: (entityModel) => _onEntityTap(context, entityModel),
          expandedUrlToIgnore: model.tweet.quotedStatusPermalink?.expanded,
        ),
      );
    } else {
      return Container();
    }
  }
}

/// If the [Tweet] has been translated this builds the translation info and
/// the translated text.
class _TweetTranslation extends StatelessWidget {
  const _TweetTranslation(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    // progress indicator
    if (model.translating) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // build nothing
    if (!model.isTranslated || model.translationUnchanged) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8.0),

        // original language text
        model.translation.language != null
            ? Row(
                children: <Widget>[
                  Text(
                    "Translated from ",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Text(model.translation.language),
                ],
              )
            : Container(),

        SizedBox(height: 4.0),

        // text
        TwitterText(
          text: model.translation.text,
          entities: model.tweet.entities,
        ),
      ],
    );
  }
}

/// If the [Tweet] contains [TweetMedia] this builds the [OldCollapsibleMedia]
/// for this [Tweet].
class _TweetMedia extends StatelessWidget {
  const _TweetMedia(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (model.hasMedia) {
      return CollapsibleMedia();
    } else {
      return Container();
    }
  }
}

/// Builds a row with the actions (favorite, retweet, translate).
class _TweetActionsRow extends StatelessWidget {
  const _TweetActionsRow(this.model);

  final TweetModel model;

  Widget _buildTranslationButton(BuildContext context) {
    final model = TweetModel.of(context);

    if (model.tweet.emptyText || model.tweet.lang == "en") {
      return Container();
    }

    VoidCallback onPressed;
    bool drawColorOnHighlight = false;
    Color color = Colors.blue;

    if (model.originalTweet.harpyData.translation == null &&
        !model.translating) {
      drawColorOnHighlight = true;

      onPressed = () async {
        await model.translate();

        if (model.translationUnchanged) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Tweet not translated"),
          ));
        }
      };
    } else if (model.translationUnchanged) {
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

  @override
  Widget build(BuildContext context) {
    if (model.quoted) {
      return Container();
    }

    return Row(
      children: <Widget>[
        // retweet action
        TwitterActionButton(
          active: model.tweet.retweeted,
          inactiveIcon: Icons.repeat,
          activeIcon: Icons.repeat,
          text: model.retweetCount,
          color: Colors.green,
          activate: model.retweet,
          deactivate: model.unretweet,
        ),

        // favorite action
        TwitterActionButton(
          active: model.tweet.favorited,
          inactiveIcon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          text: model.favoriteCount,
          color: Colors.red,
          activate: model.favorite,
          deactivate: model.unfavorite,
        ),

        Spacer(),

        _buildTranslationButton(context),
      ],
    );
  }
}
