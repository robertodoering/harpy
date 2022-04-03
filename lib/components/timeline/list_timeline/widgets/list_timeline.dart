import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ListTimeline extends ConsumerWidget {
  const ListTimeline({
    required this.listId,
    required this.listName,
    this.beginSlivers = const [],
    this.endSlivers = const [],
  });

  final String listId;
  final String listName;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

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
      onChangeFilter: () => router.pushNamed(
        ListTimelineFilter.name,
        params: {'listId': listId},
        queryParams: {'name': listName},
      ),
    );
  }
}
