import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  static const String route = 'search';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      body: BlocProvider<TrendsBloc>(
        create: (_) => TrendsBloc()..add(const FindTrendsEvent()),
        child: const SearchScreenContent(
          beginSlivers: [
            HarpySliverAppBar(title: 'search'),
          ],
          isHome: false,
        ),
      ),
    );
  }
}
