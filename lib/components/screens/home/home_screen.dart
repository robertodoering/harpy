import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/likes/cubit/likes_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/retweets/cubit/retweets_cubit.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/like_sort_by_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  static const route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(context);

    context.read<HomeTimelineCubit>().loadInitial();
    context.read<MentionsTimelineCubit>().load(
          clearPrevious: true,
          viewedMentions: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeTabModel()),
          ChangeNotifierProvider(create: (_) => TimelineFilterModel.home()),
          ChangeNotifierProvider(create: (_) => UserListSortByModel.sort()),
          BlocProvider(create: (_) => TrendsLocationsCubit()..load()),
          BlocProvider(create: (_) => TrendsCubit()..findTrends()),
          BlocProvider(create: (_) => LikesCubit()),
          BlocProvider(create: (_) => RetweetsCubit(tweetId: '')),
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
