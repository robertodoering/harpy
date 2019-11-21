import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/screens/webview_screen.dart';
import 'package:harpy/components/widgets/media/tweet_media.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/flare_buttons.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/components/widgets/shared/scroll_direction_listener.dart';
import 'package:harpy/components/widgets/shared/twitter_text.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_quote.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/tweet_model.dart';

class TweetTileContent extends StatefulWidget {
  @override
  _TweetTileContentState createState() => _TweetTileContentState();
}

class _TweetTileContentState extends State<TweetTileContent>
    with SingleTickerProviderStateMixin<TweetTileContent> {
  List<Widget> _buildContent(TweetModel model) {
    return [
      TweetRetweetedRow(model),
      _TweetContentPadding(
        model,
        children: <Widget>[
          TweetTopRow(model),
          TweetText(model),
          TweetQuote(model),
          TweetTranslation(model),
          if (model.hasMedia) CollapsibleMedia(),
          TweetActionsRow(model),
        ],
      ),
    ];
  }

  List<Widget> _buildHidden(TweetModel model) {
    final textTheme = Theme.of(context).textTheme;

    return [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 40,
              child: Icon(Icons.visibility_off, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "@${model.tweet.user.screenName}",
                style: textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            HarpyButton.flat(
              text: 'Show',
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              onTap: model.toggleVisibility,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);
    final mediaQuery = MediaQuery.of(context);
    final scrollDirection = ScrollDirection.of(context);

    // only slide and fade in the tweet tile from the right when scrolling down
    final offset = scrollDirection.direction == VerticalDirection.up
        ? const Offset(0, 0)
        : Offset(mediaQuery.size.width / 2, 0);

    final duration = scrollDirection.direction == VerticalDirection.up
        ? Duration.zero
        : const Duration(milliseconds: 300);

    return SlideFadeInAnimation(
      duration: duration,
      offset: offset,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!model.hidden) {
            HarpyNavigator.pushTweetRepliesScreen(model.tweet);
          }
        },
        child: AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (model.hidden)
                ..._buildHidden(model)
              else
                ..._buildContent(model),
              const TweetDivider(),
              if (model.replyAuthors != null)
                TweetReplyParent(
                  authors: model.replyAuthors,
                  isReply: model.isReply,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the names of the users that replied to this tweet.
class TweetReplyParent extends StatelessWidget {
  const TweetReplyParent({
    @required this.authors,
    this.isReply = false,
  });

  final String authors;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isReply ? 56 : 8, 8, 8, 0),
      child: IconRow(
        icon: Icons.reply,
        iconPadding: 40, // same as avatar width
        child: authors,
      ),
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
      padding: EdgeInsets.fromLTRB(model.isReply ? 56 : 8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// If the [Tweet] is a retweet this builds information of the person that
/// retweeted this [Tweet].
class TweetRetweetedRow extends StatelessWidget {
  const TweetRetweetedRow(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (model.isRetweet) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: IconRow(
          icon: Icons.repeat,
          iconPadding: 40, // same as avatar width
          child: "${model.originalTweet.user.name} retweeted",
        ),
      );
    } else {
      return Container();
    }
  }
}

/// Builds the [Tweet] avatar next to the [TweetNameColumn] and a
/// [PopupMenuButton] on the right.
class TweetTopRow extends StatelessWidget {
  const TweetTopRow(this.model);

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
          onTap: () => HarpyNavigator.pushUserProfileScreen(
            user: model.tweet.user,
          ),
          child: Row(
            children: <Widget>[
              CachedCircleAvatar(imageUrl: imageUrl),
              const SizedBox(width: 8),
            ],
          ),
        ),

        // name
        Expanded(child: TweetNameColumn(model)),

        // action menu
        TweetActionMenu(model),
      ],
    );
  }
}

/// Builds a [PopupMenuButton] with additional actions for the tweet.
class TweetActionMenu extends StatelessWidget {
  const TweetActionMenu(this.model);

  final TweetModel model;

  void _onSelected(TweetActionMenuEntry selection) {
    switch (selection) {
      case TweetActionMenuEntry.share:
        model.share();
        break;
      case TweetActionMenuEntry.delete:
        model.delete();
        break;
      case TweetActionMenuEntry.hide:
        model.toggleVisibility();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TweetActionMenuEntry>(
      icon: Icon(Icons.keyboard_arrow_down),
      onSelected: _onSelected,
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: TweetActionMenuEntry.share,
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text("Share"),
          ),
        ),
        if (model.isAuthorizedUserTweet)
          const PopupMenuItem(
            value: TweetActionMenuEntry.delete,
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text("Delete"),
            ),
          )
        else
          const PopupMenuItem(
            value: TweetActionMenuEntry.hide,
            child: ListTile(
              leading: Icon(Icons.visibility_off),
              title: Text("Hide"),
            ),
          ),
      ],
    );
  }
}

/// The selections for the [TweetActionMenu].
enum TweetActionMenuEntry {
  share,
  delete,
  hide,
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => HarpyNavigator.pushUserProfileScreen(user: model.tweet.user),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNameRow(),
          Text(
            model.screenNameAndTime,
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }
}

void _onEntityTap(BuildContext context, TwitterEntityModel entityModel) {
  if (entityModel.type == EntityType.url) {
    if (MediaSettingsModel.of(context).openLinksExternally) {
      launchUrl(entityModel.data);
    } else {
      HarpyNavigator.push(
        WebviewScreen(
          url: entityModel.data,
          displayUrl: entityModel.displayText,
        ),
        name: "webview",
      );
    }
  } else if (entityModel.type == EntityType.mention) {
    HarpyNavigator.pushUserProfileScreen(userId: entityModel.id);
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
          text: model.text,
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
class TweetTranslation extends StatefulWidget {
  TweetTranslation(this.model);

  final TweetModel model;

  @override
  _TweetTranslationState createState() => _TweetTranslationState();
}

class _TweetTranslationState extends State<TweetTranslation>
    with SingleTickerProviderStateMixin<TweetTranslation> {
  Widget _buildTranslatingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTranslatedText(BuildContext context) {
    final language = widget.model.translation?.language ?? "Unknown";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8, width: double.infinity),

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
          text: widget.model.translation.text,
          entities: widget.model.tweet.entities,
          onEntityTap: (entityModel) => _onEntityTap(context, entityModel),
          expandedUrlToIgnore:
              widget.model.tweet.quotedStatusPermalink?.expanded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.model.translating) {
      // progress indicator
      child = _buildTranslatingIndicator();
    } else if (!widget.model.isTranslated ||
        widget.model.translationUnchanged) {
      // build nothing
      child = Container();
    } else {
      child = _buildTranslatedText(context);
    }

    return AnimatedSize(
      vsync: this,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}

/// Builds a row with the actions (favorite, retweet, translate).
class TweetActionsRow extends StatelessWidget {
  const TweetActionsRow(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (model.isQuote == true) {
      return Container();
    }

    final retweeted = model.tweet.retweeted;

    // todo: the first icon should be aligned with the retweet / hidden icon
    return Row(
      children: <Widget>[
        HarpyButton.flat(
          onTap: retweeted ? model.unretweet : model.retweet,
          icon: Icons.repeat,
          text: model.retweetCount,
          foregroundColor: retweeted ? Colors.green : null,
          iconSize: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        FavoriteButton(
          favorited: model.tweet.favorited,
          text: model.favoriteCount,
          favorite: model.favorite,
          unfavorite: model.unfavorite,
        ),
        if (model.allowTranslation) ...[
          Spacer(),
          _TweetTranslationButton(model),
        ],
      ],
    );
  }
}

class _TweetTranslationButton extends StatelessWidget {
  const _TweetTranslationButton(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    final enable =
        model.originalTweet.harpyData.translation == null && !model.translating;

    final color =
        model.translationUnchanged ? Theme.of(context).disabledColor : null;

    return HarpyButton.flat(
      onTap: enable ? model.translate : null,
      foregroundColor:
          model.isTranslated || model.translating ? Colors.blue : color,
      icon: Icons.translate,
      iconSize: 20,
      dense: true,
    );
  }
}
