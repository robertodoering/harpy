import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds the dependencies for the home screen.
class HomeProvider extends StatelessWidget {
  const HomeProvider({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabModel>(
      create: (_) => HomeTabModel(),
      child: ChangeNotifierProvider<TimelineFilterModel>(
        create: (_) => TimelineFilterModel.home(),
        child: BlocProvider<TrendsLocationsBloc>(
          create: (_) =>
              TrendsLocationsBloc()..add(const LoadTrendsLocations()),
          child: BlocProvider<TrendsBloc>(
            create: (_) => TrendsBloc()..add(const FindTrendsEvent()),
            child: Builder(
              builder: (context) => HomeListsProvider(
                model: context.watch<HomeTabModel>(),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
