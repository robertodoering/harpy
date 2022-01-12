import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/timeline/filter/widgets/timeline_filter_creation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/buttons/harpy_button.dart';
import 'package:harpy/harpy_widgets/misc/harpy_list_card.dart';
import 'package:provider/provider.dart';

class TimelineFilterSelection extends StatelessWidget {
  const TimelineFilterSelection({
    required this.type,
  });

  final TimelineFilterType type;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TimelineFilterCubit>();
    final state = cubit.state;

    return HarpyScaffold(
      body: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(
            title: 'timeline filter selection',
            floating: true,
          ),
          if (state.timelineFilters.isNotEmpty) ...[
            SliverPadding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              sliver: const _TimelineFilterList(),
            ),
            const SliverToBoxAdapter(child: verticalSpacer),
            SliverPadding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              sliver: const SliverToBoxAdapter(child: _AddNewFilterCard()),
            ),
          ] else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: HarpyButton.flat(
                  padding: config.edgeInsets,
                  icon: const Icon(CupertinoIcons.add),
                  text: const Text('add new filter'),
                  onTap: () => _openFilterCreation(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineFilterList extends StatelessWidget {
  const _TimelineFilterList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimelineFilterCubit>();
    final state = cubit.state;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => HarpyListCard(
          title: Text(state.timelineFilters[index].name), // TODO: filter card
        ),
        childCount: state.timelineFilters.length,
      ),
    );
  }
}

class _AddNewFilterCard extends StatelessWidget {
  const _AddNewFilterCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.add),
      title: const Text('add new filter'),
      border: Border.all(color: theme.dividerColor),
      onTap: () => _openFilterCreation(context),
    );
  }
}

Future<void> _openFilterCreation(BuildContext context) {
  return Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => const TimelineFilterCreation(),
    ),
  );
}
