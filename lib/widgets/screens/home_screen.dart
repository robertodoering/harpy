import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/widgets/shared/animations.dart';
import 'package:harpy/widgets/shared/buttons.dart';
import 'package:harpy/widgets/shared/home_drawer.dart';
import 'package:harpy/widgets/shared/media/twitter_media.dart';
import 'package:harpy/widgets/shared/misc.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/twitter_text.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      appBar: "Harpy",
      body: TweetList<HomeTimelineModel>(),
      drawer: HomeDrawer(),
    );
  }
}

class TweetList<T extends TimelineModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<T>(
      builder: (context, oldChild, timelineModel) {
        return _buildList(timelineModel.tweets);
      },
    );
  }

  Widget _buildList(List<Tweet> tweets) {
    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return TweetTile(tweets[index]);
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }
}

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
                  _buildNameRow(context, model),
                  _buildText(model),
                  _buildTranslation(model),
                  _buildMedia(model),
                  _buildActionRow(model),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// If this is a retweet this builds information of the person that retweeted
  /// this [Tweet].
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

  /// Builds an avatar and the name of the author of the [Tweet].
  Widget _buildNameRow(BuildContext context, TweetModel model) {
    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap: null, // todo: go to user screen
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
              onTap: null, // todo: go to user screen
              child: Text(model.tweet.user.name),
            ),

            // username · time since tweet in hours
            GestureDetector(
              onTap: null, // todo: go to user screen
              child: Text(
                "@${model.tweet.user.screenName} \u00b7 ${tweetTimeDifference(model.tweet.createdAt)}",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ],
    );
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

  /// If the [Tweet] has been translated this builds the translation info and
  /// the translated text.
  Widget _buildTranslation(TweetModel model) => Container(); // todo

  /// If the [Tweet] contains [TweetMedia] this builds the [CollapsibleMedia]
  /// for this [Tweet].
  Widget _buildMedia(TweetModel model) {
    if (model.hasMedia) {
      return CollapsibleMedia(tweet: model.tweet);
    } else {
      return Container();
    }
  }

  /// Builds a row with the actions (favorite, retweet, translate).
  Widget _buildActionRow(TweetModel model) {
    return Row(
      children: <Widget>[
        // retweet action
        TwitterActionButton(
          active: model.tweet.retweeted,
          inactiveIcon: Icons.repeat,
          activeIcon: Icons.repeat,
          text: model.retweetCount,
          color: Colors.green,
          activate: null, // todo: retweet
          deactivate: null, // todo: unretweet
        ),

        // favorite action
        TwitterActionButton(
          active: model.tweet.favorited,
          inactiveIcon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          text: model.favoriteCount,
          color: Colors.red,
          activate: null, // todo: favorite
          deactivate: null, // todo: unfavorite
        ),

        Expanded(child: Container()),

//        _buildTranslationButton(context), // todo: translation button
      ],
    );
  }
}
