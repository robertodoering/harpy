import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    required this.trendsBloc,
  });

  static const String route = 'search';

  final TrendsBloc trendsBloc;

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      body: BlocProvider<TrendsBloc>.value(
        value: trendsBloc,
        child: const SearchScreenContent(
          beginSlivers: [
            HarpySliverAppBar(title: 'search'),
          ],
        ),
      ),
    );
  }
}
