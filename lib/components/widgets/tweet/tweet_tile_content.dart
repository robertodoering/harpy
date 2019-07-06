import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/user_profile_screen.dart';
import 'package:harpy/components/screens/webview_screen.dart';
import 'package:harpy/components/widgets/media/tweet_media.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/flare_buttons.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/components/widgets/shared/twitter_text.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_quote.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
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
        _TweetContentPadding(
          model,
          children: <Widget>[
            _TweetAvatarNameRow(model),
            TweetText(model),
            TweetQuote(model),
            _TweetTranslation(model, vsync: this),
            _TweetMedia(model),
            _TweetActionsRow(model),
          ],
        ),
        _TweetReplyParent(model),
      ],
    );
  }
}

/// Displays the names of the users that replied to this tweet if they are
/// following.
class _TweetReplyParent extends StatelessWidget {
  const _TweetReplyParent(
    this.model,
  );

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (model.tweet.harpyData.parentOfReply == false) {
      return Container();
    }

    final String replyAuthors = model.getReplyAuthors();

    if (replyAuthors.isEmpty) {
      return Container();
    }

    return Column(
      children: <Widget>[
        const Divider(height: 8),
        Padding(
          padding: EdgeInsets.fromLTRB(model.isReply ? 56 : 8, 4, 0, 8),
          child: IconRow(
            icon: Icons.reply,
            iconPadding: 40, // same as avatar width
            child: replyAuthors,
          ),
        ),
      ],
    );
  }
}

/// The padding for the tweet content.
///
/// If the tweet is a reply it has a larger padding on the left.
class _TweetContentPadding extends StatelessWidget {
  const _TweetContentPadding(
    this.model, {
    this.children,
  });

  final TweetModel model;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(model.isReply ? 56 : 8, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
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
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: IconRow(
              icon: Icons.repeat,
              iconPadding: 40, // same as avatar width
              child: "${model.originalTweet.user.name} retweeted",
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 8),
        ],
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
    final mediaSettingsModel = MediaSettingsModel.of(context);

    final String imageUrl = model.tweet.user.getProfileImageUrlFromQuality(
      mediaSettingsModel.quality,
    );

    return Row(
      children: <Widget>[
        // avatar
        GestureDetector(
          onTap: () => _openUserProfile(context, model.tweet.user),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(child: TweetNameColumn(model)),
      ],
    );
  }
}

/// Builds the name with the username and the time since tweet in hours.
class TweetNameColumn extends StatelessWidget {
  const TweetNameColumn(this.model);

  final TweetModel model;

  Widget _buildNameRow() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            model.tweet.user.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (model.tweet.user.verified)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.verified_user, size: 16),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // name
        GestureDetector(
          onTap: () => _openUserProfile(context, model.tweet.user),
          child: _buildNameRow(),
        ),

        // username · time since tweet in hours
        GestureDetector(
          onTap: () => _openUserProfile(context, model.tweet.user),
          child: Text(
            model.screenNameAndTime,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ],
    );
  }
}

/// Navigates to the [UserProfileScreen] for the [user].
void _openUserProfile(BuildContext context, User user) {
  HarpyNavigator.push(UserProfileScreen(user: user));
}

void _onEntityTap(BuildContext context, TwitterEntityModel entityModel) {
  if (entityModel.type == EntityType.url) {
    HarpyNavigator.push(
      WebviewScreen(
        url: entityModel.data,
        displayUrl: entityModel.displayText,
      ),
    );
  } else if (entityModel.type == EntityType.mention) {
    HarpyNavigator.push(UserProfileScreen(userId: entityModel.id));
  }
}

/// Builds the text of the [Tweet].
class TweetText extends StatelessWidget {
  const TweetText(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (!model.tweet.emptyText) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TwitterText(
          text: model.tweet.fullText,
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
  const _TweetTranslation(
    this.model, {
    @required this.vsync,
  });

  final TweetModel model;
  final TickerProvider vsync;

  Widget _buildTranslatingIndicator() {
    return Center(
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTranslatedText(BuildContext context) {
    final language = model.translation?.language ?? "Unknown";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),

        // original language text
        Text.rich(TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "Translated from",
              style: Theme.of(context).textTheme.body2,
            ),
            TextSpan(
              text: " $language",
            ),
          ],
        )),

        const SizedBox(height: 4),

        // text
        TwitterText(
          text: model.translation.text,
          entities: model.tweet.entities,
          onEntityTap: (entityModel) => _onEntityTap(context, entityModel),
          expandedUrlToIgnore: model.tweet.quotedStatusPermalink?.expanded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (model.translating) {
      // progress indicator
      child = _buildTranslatingIndicator();
    } else if (!model.isTranslated || model.translationUnchanged) {
      // build nothing
      child = Container();
    } else {
      child = _buildTranslatedText(context);
    }

    return AnimatedSize(
      vsync: vsync,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}

/// If the [Tweet] contains [TweetMedia] this builds the [CollapsibleMedia] for
/// this [Tweet].
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

  Future<void> _translate(BuildContext context) async {
    await model.translate();

    if (model.translationUnchanged) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text("Tweet not translated"),
      ));
    }
  }

  Widget _buildTranslationButton(BuildContext context) {
    if (model.tweet.emptyText || model.tweet.lang == "en") {
      return Container();
    }

    VoidCallback onTap;
    bool alwaysColored = false;
    Color color = Colors.blue;

    if (model.originalTweet.harpyData.translation == null &&
        !model.translating) {
      onTap = () => _translate(context);
    } else if (model.translationUnchanged) {
      color = Theme.of(context).disabledColor;
      alwaysColored = true;
    } else {
      alwaysColored = true;
    }

    return FlatHarpyButton(
      icon: Icons.translate,
      onTap: onTap,
      color: color,
      alwaysColored: alwaysColored,
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
        FlatHarpyActionButton(
          active: model.tweet.retweeted,
          inactiveIcon: Icons.repeat,
          activeIcon: Icons.repeat,
          text: model.retweetCount,
          color: Colors.green,
          activate: model.retweet,
          deactivate: model.unretweet,
        ),

        // favorite action
        FavoriteButton(
          favorited: model.tweet.favorited,
          text: model.favoriteCount,
          favorite: model.favorite,
          unfavorite: model.unfavorite,
        ),

        Spacer(),

        _buildTranslationButton(context),
      ],
    );
  }
}
