import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TimelineFilterSelection extends StatelessWidget {
  const TimelineFilterSelection.home({
    required this.onSelected,
    required this.onClearSelection,
  })  : type = TimelineFilterType.home,
        user = null,
        list = null;

  const TimelineFilterSelection.user({
    required UserData this.user,
    required this.onSelected,
    required this.onClearSelection,
  })  : type = TimelineFilterType.user,
        list = null;

  const TimelineFilterSelection.list({
    required TwitterListData this.list,
    required this.onSelected,
    required this.onClearSelection,
  })  : type = TimelineFilterType.list,
        user = null;

  /// Determines the origin of the timeline selection.
  ///
  /// Used to display the currently active filter (if any).
  final TimelineFilterType? type;

  final UserData? user;
  final TwitterListData? list;

  final ValueChanged<String> onSelected;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimelineFilterSelectionCubit(
        timelineFilterCubit: context.read(),
        type: type,
        user: user,
        list: list,
      ),
      child: HarpyScaffold(
        body: _Content(
          onSelected: onSelected,
          onClearSelection: onClearSelection,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.onSelected,
    required this.onClearSelection,
  });

  final ValueChanged<String> onSelected;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TimelineFilterSelectionCubit>();
    final state = cubit.state;

    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(
          title: 'timeline filters',
          floating: true,
        ),
        const SliverToBoxAdapter(child: verticalSpacer),
        ...?state.whenOrNull(
          noFilters: () => [
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: _AddNewFilterButton()),
            ),
          ],
          data: (sortedFilters, hasSelection) => [
            if (hasSelection) ...[
              SliverPadding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                sliver: SliverToBoxAdapter(
                  child: _ClearFilterCard(onClearSelection: onClearSelection),
                ),
              ),
              const SliverToBoxAdapter(child: verticalSpacer),
            ],
            SliverPadding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              sliver: _TimelineFilterList(
                sortedFilters: sortedFilters,
                onSelected: onSelected,
              ),
            ),
            const SliverToBoxAdapter(child: verticalSpacer),
            SliverPadding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              sliver: const SliverToBoxAdapter(child: _AddNewFilterCard()),
            ),
          ],
        ),
        const SliverBottomPadding(),
      ],
    );
  }
}

class _TimelineFilterList extends StatelessWidget {
  const _TimelineFilterList({
    required this.sortedFilters,
    required this.onSelected,
  });

  final BuiltList<SortedTimelineFilter> sortedFilters;
  final ValueChanged<String> onSelected;

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isEven) {
      return TimelineFilterCard(
        sortedFilter: sortedFilters[index ~/ 2],
        onSelected: onSelected,
      );
    } else {
      return verticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        _itemBuilder,
        childCount: sortedFilters.length * 2 - 1,
      ),
    );
  }
}

class _ClearFilterCard extends StatelessWidget {
  const _ClearFilterCard({
    required this.onClearSelection,
  });

  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    return HarpyListCard(
      color: Colors.transparent,
      title: const Text('clear selection'),
      onTap: onClearSelection,
    );
  }
}

class _AddNewFilterCard extends StatelessWidget {
  const _AddNewFilterCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return HarpyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.add),
      title: const Text('add new filter'),
      border: Border.all(color: theme.dividerColor),
      onTap: () => _openFilterCreation(context, cubit),
    );
  }
}

class _AddNewFilterButton extends StatelessWidget {
  const _AddNewFilterButton();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return HarpyButton.flat(
      padding: config.edgeInsets,
      icon: const Icon(CupertinoIcons.add),
      text: const Text('add new filter'),
      onTap: () => _openFilterCreation(context, cubit),
    );
  }
}

Future<void> _openFilterCreation(
  BuildContext context,
  TimelineFilterSelectionCubit cubit,
) async {
  await Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => const TimelineFilterCreation(),
    ),
  );

  cubit.sortTimelineFilters();
}
