import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';

class ListTimeline extends StatelessWidget {
  const ListTimeline({
    required this.listId,
    required this.listName,
    this.beginSlivers = const [],
    this.endSlivers = const [],
    this.refreshIndicatorOffset,
    this.scrollToTopOffset,
  });

  final String listId;
  final String listName;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;
  final double? scrollToTopOffset;

  @override
  Widget build(BuildContext context) {
    return Timeline(
      provider: listTimelineProvider(listId),
      listKey: PageStorageKey('list_timeline_$listId'),
      beginSlivers: [
        ...beginSlivers,
        ListTimelineTopActions(
          listId: listId,
          listName: listName,
        ),
      ],
      refreshIndicatorOffset: refreshIndicatorOffset,
      scrollToTopOffset: scrollToTopOffset,
      onChangeFilter: () => context.pushNamed(
        ListTimelineFilter.name,
        params: {'listId': listId},
        queryParams: {'name': listName},
      ),
    );
  }
}
