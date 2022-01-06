import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ListTimeline extends StatelessWidget {
  const ListTimeline({
    this.name,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
  });

  final String? name;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ListTimelineCubit>();
    final state = cubit.state;

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: PageStorageKey('list_timeline_${cubit.listId}'),
        beginSlivers: [
          ...beginSlivers,
          if (state.hasTweets) _TopRow(listId: cubit.listId, name: name),
        ],
        endSlivers: endSlivers,
        refreshIndicatorOffset: refreshIndicatorOffset,
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.listId,
    this.name,
  });

  final String listId;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<ListTimelineCubit>();

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
              onTap: () => cubit.load(clearPrevious: true),
            ),
            const Spacer(),
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: const Icon(CupertinoIcons.person_2),
              onTap: () => app<HarpyNavigator>().pushListMembersScreen(
                listId: listId,
                name: name,
              ),
            ),
            horizontalSpacer,
            HarpyButton.raised(
              padding: config.edgeInsets,
              elevation: 0,
              backgroundColor: theme.cardTheme.color,
              icon: cubit.filter != OldTimelineFilter.empty
                  ? Icon(Icons.filter_alt, color: theme.colorScheme.primary)
                  : const Icon(Icons.filter_alt_outlined),
              onTap: Scaffold.of(context).openEndDrawer,
            ),
          ],
        ),
      ),
    );
  }
}
