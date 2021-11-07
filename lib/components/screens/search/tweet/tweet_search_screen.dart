import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetSearchScreen extends StatelessWidget {
  const TweetSearchScreen({
    this.initialQuery,
  });

  final String? initialQuery;

  static const route = 'tweet_search';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TweetSearchFilterModel(TweetSearchFilter.empty),
      child: BlocProvider<TweetSearchCubit>(
        create: (_) => TweetSearchCubit(initialQuery: initialQuery),
        child: const HarpyScaffold(
          endDrawer: TweetSearchFilterDrawer(),
          body: TweetSearchList(),
        ),
      ),
    );
  }
}
