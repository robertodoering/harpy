import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [ListTimeline] with a [BlocProvider] for the matching cubit from
/// the [HomeListsProvider].
class HomeListTimeline extends StatelessWidget {
  const HomeListTimeline({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

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
          listName: listName,
          beginSlivers: const [HomeTopSliverPadding()],
          endSlivers: const [HomeBottomSliverPadding()],
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
