import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
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
          BlocProvider(create: (_) => TrendsLocationsCubit()..load()),
          BlocProvider(create: (_) => TrendsCubit()..findTrends())
        ],
        child: Builder(
          builder: (context) => HomeListsProvider(
            model: context.read(),
            child: const HarpyScaffold(
              body: ScrollDirectionListener(
                depth: 1,
                child: HomeTabView(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
