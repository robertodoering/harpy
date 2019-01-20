import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/utils/harpy_navigator.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/widgets/screens/user_profile_screen.dart';
import 'package:harpy/widgets/shared/animations.dart';
import 'package:harpy/widgets/shared/buttons.dart';
import 'package:harpy/widgets/shared/media/twitter_media.dart';
import 'package:harpy/widgets/shared/misc.dart';
import 'package:harpy/widgets/shared/tweet/collapsible_tweet_media.dart';
import 'package:harpy/widgets/shared/twitter_text.dart';
import 'package:scoped_model/scoped_model.dart';

class TweetTile extends StatelessWidget {
  const TweetTile(this._tweet);

  final Tweet _tweet;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    return ScopedModel<TweetModel>(
      model: TweetModel(
        originalTweet: _tweet,
        tweetCache: serviceProvider.data.tweetCache,
      ),
      child: SlideFadeInAnimation(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
          child: ScopedModelDescendant<TweetModel>(
            builder: (context, _, model) {
              // the content of this tweet that rebuilds when the tweet model
              // notifies its listeners

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRetweetedRow(model),
                  _TweetNameRow(),
                  _buildText(model),
                  _TweetTranslation(),
                  _buildMedia(model),
                  _TweetActionsRow(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// If the [Tweet] is a retweet this builds information of the person that
  /// retweeted this [Tweet].
  Widget _buildRetweetedRow(TweetModel model) {
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

  /// Builds the text of the [Tweet].
  Widget _buildText(TweetModel model) {
    if (!model.tweet.emptyText) {
      return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: TwitterText(
          text: model.tweet.full_text,
          entities: model.tweet.entities,
//        onEntityTap: (model) async { // todo
//          if (model.type == EntityType.url) {
//            launchUrl(model.data);
//          } else if (model.type == EntityType.mention) {
//            _openUserProfile(context, userId: model.id);
//          }
//        },
        ),
      );
    } else {
      return Container();
    }
  }

  /// If the [Tweet] contains [TweetMedia] this builds the [OldCollapsibleMedia]
  /// for this [Tweet].
  Widget _buildMedia(TweetModel model) {
    if (model.hasMedia) {
      return CollapsibleMedia();
    } else {
      return Container();
    }
  }
}

/// Build the [Tweet] avatar and name + username.
class _TweetNameRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);

    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap: () => _goToUserProfile(context, model.tweet.user),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              model.tweet.user.userProfileImageOriginal,
            ),
          ),
        ),

        SizedBox(width: 8.0),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // name
            GestureDetector(
              onTap: () => _goToUserProfile(context, model.tweet.user),
              child: Text(model.tweet.user.name),
            ),

            // username · time since tweet in hours
            GestureDetector(
              onTap: () => _goToUserProfile(context, model.tweet.user),
              child: Text(
                model.screenNameAndTime,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _goToUserProfile(BuildContext context, User user) {
    HarpyNavigator.push(
      context,
      UserProfileScreen(
        user: user,
      ),
    );
  }
}

/// If the [Tweet] has been translated this builds the translation info and
/// the translated text.
class _TweetTranslation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);

    if (model.translating) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!model.isTranslated || model.translationUnchanged) {
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
            Text(model.translation.language), // todo: check if not null
          ],
        ),
        SizedBox(height: 4.0),
        TwitterText(
          text: model.translation.text,
          entities: model.tweet.entities,
        ),
      ],
    );
  }
}

/// Builds a row with the actions (favorite, retweet, translate).
class _TweetActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);

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

        Expanded(child: Container()),

        _buildTranslationButton(context),
      ],
    );
  }

  Widget _buildTranslationButton(BuildContext context) {
    final model = TweetModel.of(context);

    if (model.tweet.emptyText || model.tweet.lang == "en") {
      return Container();
    }

    VoidCallback onPressed;
    bool drawColorOnHighlight = false;
    Color color = Colors.blue;

    if (model.tweet.harpyData.translation == null && !model.translating) {
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
}
