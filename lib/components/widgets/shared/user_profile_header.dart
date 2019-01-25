import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/components/widgets/shared/twitter_text.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/core/utils/date_utils.dart';

/// The [UserProfileHeader] containing the information about the [User].
///
/// todo: refactor with UserProfileModel
class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({
    @required this.user,
  });

  final User user;

  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  GestureRecognizer _linkGestureRecognizer;

  @override
  void dispose() {
    super.dispose();

    _linkGestureRecognizer?.dispose();
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
          _buildAdditionalInfo(context),
          FollowersCount(
            followers: widget.user.followersCount,
            following: widget.user.friendsCount,
          )
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
              launchUrl(entityModel.data);
            }
          },
        ),
      ],
    );
  }

  /// Builds a [Column] of icon rows with additional information such as the
  /// link, date joined or location of the [User].
  Widget _buildAdditionalInfo(BuildContext context) {
    List<Widget> children = [];

    if (widget.user?.entities?.url?.urls?.isNotEmpty ?? false) {
      children.add(_buildLink(context));
    }

    if (widget.user.location?.isNotEmpty ?? false) {
      children.add(IconRow(icon: Icons.place, child: widget.user.location));
    }

    if (widget.user.createdAt != null) {
      children.add(IconRow(
        icon: Icons.date_range,
        child: "joined ${formatCreatedAt(widget.user.createdAt)}",
      ));
    }

    return children.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: children),
          )
        : Container();
  }

  /// A helper method to create a link in [_buildAdditionalInfo].
  Widget _buildLink(BuildContext context) {
    Url url = widget.user.entities.url.urls.first;

    _linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(url.url);

    Widget text = Text.rich(
      TextSpan(
        text: "${url.displayUrl} ",
        style: Theme.of(context).textTheme.body1.copyWith(
              color: Theme.of(context).accentColor, // todo: user color?
              fontWeight: FontWeight.bold,
            ),
        recognizer: _linkGestureRecognizer,
      ),
    );

    return IconRow(icon: Icons.link, child: text);
  }
}
