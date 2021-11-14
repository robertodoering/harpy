import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [ListTimeline] with a [BlocProvider] for the matching bloc from
/// the [HomeListsProvider].
class HomeListTimeline extends StatelessWidget {
  const HomeListTimeline({
    required this.listId,
    required this.name,
  });

  final String listId;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final cubit = HomeListsProvider.cubitOf(
      context,
      listId: listId,
    );

    assert(cubit != null, 'missing list timeline cubit for home list timeline');

    if (cubit != null) {
      return BlocProvider.value(
        value: cubit,
        child: ListTimeline(
          name: name,
          beginSlivers: const [HomeTopSliverPadding()],
          refreshIndicatorOffset: config.bottomAppBar
              ? 0
              : HomeAppBar.height(context) + config.paddingValue,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
