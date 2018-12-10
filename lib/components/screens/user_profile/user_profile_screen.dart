import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/components/shared/scaffolds.dart';
import 'package:harpy/components/shared/tweet_list.dart';
import 'package:harpy/components/shared/twitter_text.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:harpy/core/utils/url_launcher.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen(this.user);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with StoreWatcherMixin<UserProfileScreen> {
  UserStore store;

  bool _loadingTweets = true;

  @override
  void initState() {
    super.initState();
    store = listenToStore(Tokens.user);

    _initUserTweets();
  }

  void _initUserTweets() {
    UserStore.initUserTweets(widget.user).then((_) {
      setState(() {
        _loadingTweets = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    List content = [
      UserHeader(user: widget.user),
    ];

    _addListBody(content);

    return Theme(
      data: HarpyTheme.theme,
      child: FadingNestedScaffold(
        title: widget.user.name,
        background: CachedNetworkImage(
          imageUrl: widget.user.profile_banner_url ??
              widget.user.profileBackgroundImageUrl,
          fit: BoxFit.cover,
        ),
        body: SlideFadeInAnimation(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: content.length,
            itemBuilder: (context, index) {
              if (content[index] is Tweet) {
                return SlideFadeInAnimation(
                  duration: Duration(milliseconds: 500),
                  child: TweetTile(
                    key: Key("${store.userTweets[index].id}"),
                    tweet: store.userTweets[index],
                  ),
                );
              } else {
                return content[index];
              }
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ),
    );
  }

  void _addListBody(List content) {
    if (_loadingTweets) {
      content.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: CircularProgressIndicator()),
      ));
    } else if (store.userTweets.isEmpty) {
      content.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: Text("No tweets q.q")),
      ));
    } else {
      content.addAll(store.userTweets);
    }
  }
}

class UserHeader extends StatefulWidget {
  final User user;

  const UserHeader({@required this.user});

  @override
  UserHeaderState createState() {
    return new UserHeaderState();
  }
}

class UserHeaderState extends State<UserHeader> {
  GestureRecognizer linkGestureRecognizer;

  @override
  void dispose() {
    super.dispose();

    linkGestureRecognizer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserInfo(),
          SizedBox(height: 8.0),
          _buildUserDescription(),
          SizedBox(height: 8.0),
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 36.0,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(
            widget.user.userProfileImageOriginal,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.user.name,
                style: Theme.of(context).textTheme.display2,
              ),
              Text(
                "@" + widget.user.screenName,
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserDescription() {
    // todo (low priority): parse hashtags in description
    return Column(
      children: <Widget>[
        TwitterText(
          text: widget.user.description,
          entities: widget.user.entities.asEntities,
          onEntityTap: (entityModel) {
            if (entityModel.type == EntityType.url) {
              launchUrl(entityModel.url);
            }
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: <Widget>[
        widget.user?.entities?.url?.urls?.isNotEmpty ?? false
            ? _buildLink()
            : Container(),
        widget.user.location?.isNotEmpty ?? false
            ? _buildIconRow(Icons.place, Text(widget.user.location))
            : Container(),
        widget.user.createdAt != null
            ? _buildIconRow(Icons.date_range,
                Text("joined ${formatCreatedAt(widget.user.createdAt)}"))
            : Container(),
      ],
    );
  }

  Widget _buildLink() {
    Url url = widget.user.entities.url.urls.first;

    linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(url.url);

    Widget text = RichText(
        text: TextSpan(
      text: "${url.displayUrl} ",
      style: HarpyTheme.theme.textTheme.body1.copyWith(
        color: HarpyTheme.primaryColor, // todo: user color?
        fontWeight: FontWeight.bold,
      ),
      recognizer: linkGestureRecognizer,
    ));

    return _buildIconRow(Icons.link, text);
  }

  Widget _buildIconRow(IconData icon, Widget text) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20.0),
        SizedBox(width: 8.0),
        text,
      ],
    );
  }
}
