import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:tuple/tuple.dart';

class ListTimelineFilter extends StatelessWidget {
  const ListTimelineFilter({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  static const name = 'list_timeline_filter';

  @override
  Widget build(BuildContext context) {
    return TimelineFilterSelection(
      provider: listTimelineFilterProvider(Tuple2(listId, listName)),
    );
  }
}
