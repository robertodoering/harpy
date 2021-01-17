import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/dialogs/changelog_dialog.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/compose/widget/compose_screen.dart';
import 'package:harpy/components/search/user/widgets/user_search_screen.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_event.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/// The home screen for an authenticated user.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.autoLogin = false,
  });

  /// Whether the user got automatically logged in when opening the app
  /// (previous session got restored).
  final bool autoLogin;

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    if (widget.autoLogin == true) {
      ChangelogDialog.maybeShow(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // force a rebuild when the home screen shows again
    setState(() {});
  }

  void _onScrollDirectionChanged(VerticalDirection direction) {
    final bool show = direction != VerticalDirection.down;

    if (_showFab != show) {
      setState(() {
        _showFab = show;
      });
    }
  }

  List<Widget> _buildActions() {
    return <Widget>[
      Builder(
        builder: (BuildContext context) => PopupMenuButton<int>(
          onSelected: (int selection) {
            if (selection == 0) {
              context.read<HomeTimelineBloc>()
                ..add(const ClearTweetsEvents())
                ..add(const UpdateHomeTimelineEvent());
            } else if (selection == 1) {
              app<HarpyNavigator>().pushNamed(UserSearchScreen.route);
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(value: 0, child: Text('Refresh')),
              const PopupMenuItem<int>(value: 1, child: Text('Search users')),
            ];
          },
        ),
      ),
    ];
  }

  Widget _buildFloatingActionButton() {
    if (_showFab) {
      return FloatingActionButton(
        onPressed: () => app<HarpyNavigator>().pushNamed(ComposeScreen.route),
        child: const Icon(LineAwesomeIcons.alternate_feather, size: 30),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      onScrollDirectionChanged: _onScrollDirectionChanged,
      child: HarpyScaffold(
        drawer: const HomeDrawer(),
        floatingActionButton: _buildFloatingActionButton(),
        body: BlocProvider<HomeTimelineBloc>(
          create: (BuildContext context) => HomeTimelineBloc(),
          child: TweetTimeline<HomeTimelineBloc>(
            headerSlivers: <Widget>[
              HarpySliverAppBar(
                title: 'Harpy',
                showIcon: true,
                floating: true,
                actions: _buildActions(),
              ),
            ],
            refreshIndicatorDisplacement: 80,
            onRefresh: (HomeTimelineBloc bloc) {
              bloc.add(const UpdateHomeTimelineEvent());
              return bloc.updateTimelineCompleter.future;
            },
            onLoadMore: (HomeTimelineBloc bloc) {
              bloc.add(const RequestMoreHomeTimelineEvent());
              return bloc.requestMoreCompleter.future;
            },
          ),
        ),
      ),
    );
  }
}
