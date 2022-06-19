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
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final general = ref.watch(generalPreferencesProvider);

    return Timeline(
      provider: listTimelineProvider(listId),
      listKey: general.restoreScrollPositions
          ? PageStorageKey('list_timeline_$listId')
          : null,
      beginSlivers: [
        ...beginSlivers,
        ListTimelineTopActions(
          listId: listId,
          listName: listName,
        ),
      ],
      refreshIndicatorOffset: refreshIndicatorOffset,
      scrollToTopOffset: scrollToTopOffset,
      onChangeFilter: () => router.pushNamed(
        ListTimelineFilter.name,
        params: {'listId': listId},
        queryParams: {'name': listName},
      ),
    );
  }
}
