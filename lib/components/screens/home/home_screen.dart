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
          // TODO: consider making trends cubits global to avoid having to pass
          //  them to the search screen
          BlocProvider(create: (_) => TrendsLocationsCubit()..load()),
          BlocProvider(create: (_) => TrendsCubit()..findTrends())
        ],
        child: Builder(
          builder: (context) => HomeListsProvider(
            model: context.read(),
            child: const ScrollDirectionListener(
              depth: 1,
              child: HarpyScaffold(
                body: FloatingComposeButton(
                  child: HomeTabView(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
