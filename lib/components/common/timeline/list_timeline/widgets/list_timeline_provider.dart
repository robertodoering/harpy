import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [ListTimeline] with a [ListTimelineBloc].
class ListTimelineProvider extends StatelessWidget {
  const ListTimelineProvider({
    @required this.listId,
  });

  final String listId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListTimelineBloc>(
      create: (_) => ListTimelineBloc(listId: listId),
      child: ListTimeline(listId: listId),
    );
  }
}
