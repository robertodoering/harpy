import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_event.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      drawer: const HomeDrawer(),
      body: BlocProvider<HomeTimelineBloc>(
        create: (BuildContext context) => HomeTimelineBloc(),
        child: TweetTimeline<HomeTimelineBloc>(
          headerSlivers: const <Widget>[
            HarpySliverAppBar(
              title: 'Harpy',
              showIcon: true,
              floating: true,
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
