import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
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
    // e.g. to rebuild after changing default padding to animate padding changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: ChangeNotifierProvider<HomeTabModel>(
        create: (_) => HomeTabModel(),
        child: ChangeNotifierProvider<TimelineFilterModel>(
          create: (_) => TimelineFilterModel.home(),
          child: BlocProvider<TrendsBloc>(
            create: (_) => TrendsBloc()..add(const FindTrendsEvent.global()),
            child: Builder(
              builder: (BuildContext context) => HomeListsProvider(
                model: context.watch<HomeTabModel>(),
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
            ),
          ),
        ),
      ),
    );
  }
}
