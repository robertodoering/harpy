import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetSearchScreen extends StatelessWidget {
  const TweetSearchScreen({
    this.initialSearchQuery,
  });

  final String? initialSearchQuery;

  static const String route = 'tweet_search_screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TweetSearchFilterModel>(
      create: (_) => TweetSearchFilterModel(TweetSearchFilter.empty),
      child: BlocProvider<TweetSearchBloc>(
        create: (_) => TweetSearchBloc(initialSearchQuery: initialSearchQuery),
        child: const HarpyScaffold(
          endDrawer: TweetSearchFilterDrawer(),
          body: TweetSearchList(),
        ),
      ),
    );
  }
}
