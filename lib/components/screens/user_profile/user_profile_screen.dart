import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
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
              UserHeader(user: widget.user),
              Text("User tweets go here \\o/"),
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

class UserScaffold extends StatefulWidget {
  final User user;
  final Widget body;

  const UserScaffold({@required this.user, @required this.body});

  @override
  UserScaffoldState createState() => UserScaffoldState();
}

class UserScaffoldState extends State<UserScaffold> {
  ScrollController _controller;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        if (_controller.offset >= 100 && _controller.offset <= 160) {
          double val = _controller.offset - 100;
          setState(() {
            _opacity = val / 60.0;
          });
        } else if (_controller.offset < 100 && _opacity != 0.0) {
          setState(() {
            _opacity = 0.0;
          });
        } else if (_controller.offset > 160 && _opacity != 1.0) {
          setState(() {
            _opacity = 1.0;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Opacity(
                  opacity: _opacity,
                  child: Text(
                    widget.user.name,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                background: Image.network(
                  widget.user.profileBackgroundImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}
