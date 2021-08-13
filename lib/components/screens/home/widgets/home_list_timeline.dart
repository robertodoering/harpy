import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [ListTimeline] with a [BlocProvider] for the matching bloc from
/// the [HomeListsProvider].
class HomeListTimeline extends StatelessWidget {
  const HomeListTimeline({
    required this.listId,
  });

  final String? listId;

  @override
  Widget build(BuildContext context) {
    final bloc = HomeListsProvider.blocOf(
      context,
      listId: listId,
    );

    assert(bloc != null, 'missing list timeline bloc for home list timeline');

    // todo: add ability to refresh lists

    if (bloc != null) {
      return BlocProvider<ListTimelineBloc>.value(
        value: bloc,
        child: ListTimeline(
          listId: listId,
          beginSlivers: const [HomeTopSliverPadding()],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
