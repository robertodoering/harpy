import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/home/home_drawer.dart';
import 'package:harpy/components/screens/home/tweet_list.dart';
import 'package:harpy/theme.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen({@required this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Theme(
        data: HarpyTheme.theme,
        child: UserScaffold(
          user: widget.user,
          body: Column(
            children: <Widget>[
              UserHeader(
                user: widget.user,
              ),
              Text("User tweets go here \o/"),
              Text("User tweets go here \o/"),
              Text("User tweets go here \o/"),
              Text("User tweets go here \o/"),
            ],
          ),
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
          backgroundImage:
              CachedNetworkImageProvider(user.userProfileImageOriginal),
        ),
        SizedBox(
          width: 8.0,
        ),
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

class UserScaffold extends StatelessWidget {
  final User user;
  final Widget body;

  const UserScaffold({@required this.user, @required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Image.network(
                  user.profileBackgroundImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ];
        },
        body: body,
      ),
    );
  }
}
