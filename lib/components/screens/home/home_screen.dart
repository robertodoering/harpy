import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);

    context.read<HomeTimelineBloc>().add(const RequestInitialHomeTimeline());
    context.read<MentionsTimelineBloc>().add(const RequestMentionsTimeline());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    harpyRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    harpyRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // force a rebuild when the home screen shows again
    // e.g. to rebuild after changing default padding to animate padding changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: HomeProvider(
        // scroll direction listener has to be built above the filter
        child: ScrollDirectionListener(
          depth: 2,
          child: HarpyScaffold(
            drawer: const HomeDrawer(),
            endDrawer: const HomeTimelineFilterDrawer(),
            endDrawerEnableOpenDragGesture: false,
            body: HomeTabView(),
          ),
        ),
      ),
    );
  }
}
