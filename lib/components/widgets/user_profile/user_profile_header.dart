import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/webview_screen.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/components/widgets/shared/twitter_text.dart';
import 'package:harpy/components/widgets/user_search/user_list_tile.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/user_profile_model.dart';

/// The [UserProfileHeader] containing the information about the [User].
class UserProfileHeader extends StatefulWidget {
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

  Widget _buildUserInfo(UserProfileModel model) {
    final mediaSettingsModel = MediaSettingsModel.of(context);
    final textTheme = Theme.of(context).textTheme;

    final String imageUrl = model.user.getProfileImageUrlFromQuality(
      mediaSettingsModel.quality,
    );

    return Row(
      children: <Widget>[
        // avatar
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(imageUrl),
        ),

        const SizedBox(width: 8),

        // user name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                child: UserNameRow(
                  user: model.user,
                  style: textTheme.title,
                  iconSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text("@${model.user.screenName}", style: textTheme.subhead),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // follow button
        _buildFollowButton(model),
      ],
    );
  }

  /// Builds the button to follow / unfollow the user if it is not the logged in
  /// user.
  Widget _buildFollowButton(UserProfileModel model) {
    if (model.isLoggedInUser) {
      return Container();
    }

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: HarpyButton.raised(
        text: "Following",
        onTap: model.changeFollowState,
        dense: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      secondChild: HarpyButton.raised(
        text: "Follow",
        onTap: model.changeFollowState,
        dense: true,
      ),
      crossFadeState: model.user.following
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  Widget _buildUserDescription(UserProfileModel model) {
    if (model.user.description.trim().isEmpty) {
      return Container();
    }

    // todo (low priority): parse hashtags in description
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TwitterText(
        text: model.user.description,
        entities: model.user.entities.asEntities,
        onEntityTap: (entityModel) {
          if (entityModel.type == EntityType.url) {
            HarpyNavigator.push(
              WebviewScreen(
                url: entityModel.data,
                displayUrl: entityModel.displayText,
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds a [Column] of icon rows with additional information such as the
  /// link, date joined or location of the [User].
  Widget _buildAdditionalInfo(UserProfileModel model) {
    final children = <Widget>[];

    if (model.user.entities?.url?.urls?.isNotEmpty ?? false) {
      children.add(_buildLink(model));
    }

    if (model.user.location?.isNotEmpty ?? false) {
      children.add(IconRow(icon: Icons.place, child: model.user.location));
    }

    if (model.user.createdAt != null) {
      children.add(IconRow(
        icon: Icons.date_range,
        child: "joined ${formatCreatedAt(model.user.createdAt)}",
      ));
    }

    if (children.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }

  /// A helper method to create a link in [_buildAdditionalInfo].
  Widget _buildLink(UserProfileModel model) {
    final Url url = model.user.entities.url.urls.first;

    _linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        HarpyNavigator.push(
          WebviewScreen(
            url: url.url,
            displayUrl: url.displayUrl,
          ),
        );
      };

    final text = Text.rich(
      TextSpan(
        text: url.displayUrl,
        style: Theme.of(context).textTheme.body1.copyWith(
              color: Theme.of(context).accentColor, // todo: user color?
              fontWeight: FontWeight.bold,
            ),
        recognizer: _linkGestureRecognizer,
      ),
    );

    return IconRow(icon: Icons.link, child: text);
  }

  @override
  Widget build(BuildContext context) {
    final model = UserProfileModel.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserInfo(model),
          _buildUserDescription(model),
          _buildAdditionalInfo(model),
          FollowersCount(model.user),
        ],
      ),
    );
  }
}
