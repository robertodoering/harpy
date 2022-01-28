import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ListTimeline extends StatelessWidget {
  const ListTimeline({
    required this.listName,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
  });

  final String listName;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ListTimelineCubit>();

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: PageStorageKey('list_timeline_${cubit.listId}'),
        beginSlivers: [
          ...beginSlivers,
          _TopRow(listId: cubit.listId, listName: listName),
        ],
        endSlivers: endSlivers,
        refreshIndicatorOffset: refreshIndicatorOffset,
        onChangeFilter: () => _openListTimelineFilterSelection(
          context,
          listId: cubit.listId,
          listName: listName,
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<ListTimelineCubit>();
    final state = cubit.state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsOnly(
          top: true,
          left: true,
          right: true,
        ),
        child: Row(
          children: [
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: const Icon(CupertinoIcons.refresh),
              onTap: state.hasTweets
                  ? () => cubit.load(clearPrevious: true)
                  : null,
            ),
            const Spacer(),
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: const Icon(CupertinoIcons.person_2),
              onTap: state.hasTweets
                  ? () => app<HarpyNavigator>().pushListMembersScreen(
                        listId: listId,
                        listName: listName,
                      )
                  : null,
            ),
            horizontalSpacer,
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: cubit.filter != null
                  ? Icon(
                      Icons.filter_alt,
                      color: state.hasTweets
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(.5),
                    )
                  : const Icon(Icons.filter_alt_outlined),
              onTap: state.hasTweets
                  ? () => _openListTimelineFilterSelection(
                        context,
                        listId: listId,
                        listName: listName,
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

void _openListTimelineFilterSelection(
  BuildContext context, {
  required String listId,
  required String listName,
}) {
  Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => TimelineFilterSelection(
        blocBuilder: (context) => ListTimelineFilterCubit(
          timelineFilterCubit: context.read(),
          listId: listId,
          listName: listName,
        ),
      ),
      fullscreenDialog: true,
    ),
  );
}
