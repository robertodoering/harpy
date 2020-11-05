import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/dialogs/changelog_dialog.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_event.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// The home screen for an authenticated user.
class HomeScreen extends StatefulWidget {
  const HomeScreen();

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final ChangelogPreferences changelogPreferences = app<ChangelogPreferences>();

  @override
  void initState() {
    super.initState();

    _showChangelogDialog();
  }

  Future<void> _showChangelogDialog() async {
    if (changelogPreferences.shouldShowChangelogDialog) {
      ChangelogDialog.show(context);
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

  List<Widget> _buildActions() {
    return <Widget>[
      Builder(
        builder: (BuildContext context) => PopupMenuButton<int>(
          onSelected: (int selection) {
            if (selection == 0) {
              context.bloc<HomeTimelineBloc>()
                ..add(const ClearTweetsEvents())
                ..add(const UpdateHomeTimelineEvent());
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Refresh'),
              ),
            ];
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      drawer: const HomeDrawer(),
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
    );
  }
}
