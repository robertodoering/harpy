import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/shared/scaffolds.dart';
import 'package:harpy/theme.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen(this.user);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: FadingNestedScaffold(
        title: widget.user.name,
        background: Image.network(
          widget.user.profileBackgroundImageUrl,
          fit: BoxFit.cover,
        ),
        body: Column(
          children: <Widget>[
            UserHeader(user: widget.user),
            Text("User tweets go here \\o/"),
          ],
        ),
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  final User user;

  const UserHeader({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserInfo(context),
          SizedBox(height: 8.0),
          _buildUserDescription(context),
        ],
      ),
    );
  }

  Widget _buildUserDescription(context) {
    return Column(
      children: <Widget>[
        Text(user.description),
      ],
    );
  }

  Widget _buildUserInfo(context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 36.0,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(
            user.userProfileImageOriginal,
          ),
        ),
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user.name,
              style: Theme.of(context).textTheme.display2,
            ),
            Text(
              "@" + user.screenName,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ],
    );
  }
}
