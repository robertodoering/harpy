import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    required this.trendsCubit,
  });

  static const route = 'search';

  final TrendsCubit trendsCubit;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      body: BlocProvider<TrendsCubit>.value(
        value: trendsCubit,
        child: const SearchScreenContent(
          beginSlivers: [
            HarpySliverAppBar(title: 'search'),
          ],
        ),
      ),
    );
  }
}
