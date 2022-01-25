import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    required this.trendsCubit,
    required this.trendsLocationsCubit,
  });

  static const route = 'search';

  final TrendsCubit trendsCubit;
  final TrendsLocationsCubit trendsLocationsCubit;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: trendsCubit),
          BlocProvider.value(value: trendsLocationsCubit),
        ],
        child: const ScrollDirectionListener(
          child: SearchScreenContent(
            beginSlivers: [
              HarpySliverAppBar(title: 'search', floating: true),
            ],
          ),
        ),
      ),
    );
  }
}
