import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/__old_stores/tokens.dart';
import 'package:harpy/__old_stores/user_store.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/theme.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/tweet/old_tweet_list.dart';
import 'package:harpy/widgets/shared/user_header.dart';

/// The user profile screen to show information and the user timeline of the
/// [user].
///
/// If [user] is `null` [userId] has to not be `null` and is used to load
/// the [User].
class UserProfileScreen extends StatefulWidget {
  final User user;
  final String userId;

  UserProfileScreen({
    this.user,
    this.userId,
  }) : assert(user != null || userId != null);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with StoreWatcherMixin<UserProfileScreen> {
  UserStore store;

  bool _loadingUser = true;
  bool _loadingTweets = true;

  @override
  void initState() {
    super.initState();

    store = listenToStore(Tokens.user);
    _initUser();
  }

  void _initUser() async {
    await UserStore.initUser(widget.user);

    if (store.user != null) {
      setState(() {
        _loadingUser = false;
      });
    } else {
      UserStore.initUserFromId(widget.userId).then((_) {
        setState(() {
          _loadingUser = false;
        });
      });
    }

    // load user tweet timeline
    String userId = widget.user?.id?.toString() ?? widget.userId;

    UserStore.initUserTweets(userId).then((_) {
      setState(() {
        _loadingTweets = false;
      });
    }).catchError((_) {
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
    return Theme(
      data: HarpyTheme().theme,
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    if (_loadingUser) {
      return FadingNestedScaffold(
        background: Container(color: HarpyTheme().theme.primaryColor),
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (store.user != null) {
      return FadingNestedScaffold(
        title: store.user.name,
        background: CachedNetworkImage(
          imageUrl: store.user.profile_banner_url ??
              store.user.profileBackgroundImageUrl,
          fit: BoxFit.cover,
        ),
        body: OldTweetList(
          leading: UserProfileHeader(user: store.user),
          tweets: _loadingTweets ? null : store.userTweets,
          trailing: _buildTrailingWidget(),
          type: ListType.user,
        ),
      );
    } else {
      // user is null and not loading user: error loading user
      return FadingNestedScaffold(
        background: Container(color: HarpyTheme().theme.primaryColor),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Error loading user")),
        ),
      );
    }
  }

  /// Builds a [CircularProgressIndicator] if the tweets are loading or a [Text]
  /// if no tweets were able to be fetched.
  Widget _buildTrailingWidget() {
    if (_loadingTweets) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (store.userTweets?.isEmpty ?? false) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(child: Text("No tweets found")), // todo: i18n
      );
    } else {
      return Container();
    }
  }
}
