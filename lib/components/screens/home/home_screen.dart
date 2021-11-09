import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);

    context.read<HomeTimelineBloc>().add(const RequestInitialHomeTimeline());
    context.read<MentionsTimelineBloc>().add(const RequestMentionsTimeline());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeTabModel()),
          ChangeNotifierProvider(create: (_) => TimelineFilterModel.home()),
          BlocProvider(create: (_) => TrendsLocationsCubit()..load()),
          BlocProvider(create: (_) => TrendsCubit()..findTrends())
        ],
        child: Builder(
          builder: (context) => HomeListsProvider(
            model: context.watch<HomeTabModel>(),
            // scroll direction listener has to be built above the filter
            child: const ScrollDirectionListener(
              depth: 1,
              child: HarpyScaffold(
                endDrawer: HomeTimelineFilterDrawer(),
                body: HomeTabView(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
