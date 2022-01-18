import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class TimelineFilterSelection extends StatelessWidget {
  const TimelineFilterSelection({
    required this.blocBuilder,
  });

  final Create<TimelineFilterSelectionCubit> blocBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: blocBuilder,
      child: const HarpyScaffold(
        body: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimelineFilterSelectionCubit>();
    final state = cubit.state;

    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(
          title: 'timeline filters',
          floating: true,
        ),
        const SliverToBoxAdapter(child: verticalSpacer),
        ...?state.mapOrNull(
          noFilters: (_) => [const _AddNewFilterButton()],
          data: (data) => [
            if (data.activeFilter != null) ...const [
              _ClearFilterCard(),
              SliverToBoxAdapter(child: verticalSpacer),
            ],
            if (data.showUnique && data.uniqueName != null) ...[
              _ToggleUniqueFilterCard(
                isUnique: data.isUnique,
                uniqueName: data.uniqueName!,
              ),
              const SliverToBoxAdapter(child: verticalSpacer),
            ],
            _TimelineFilterList(sortedFilters: data.sortedFilters),
            const SliverToBoxAdapter(child: verticalSpacer),
            const _AddNewFilterCard(),
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
  });

  final BuiltList<SortedTimelineFilter> sortedFilters;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverPadding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => index.isEven
              ? TimelineFilterCard(sortedFilter: sortedFilters[index ~/ 2])
              : verticalSpacer,
          childCount: sortedFilters.length * 2 - 1,
        ),
      ),
    );
  }
}

class _ClearFilterCard extends StatelessWidget {
  const _ClearFilterCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return SliverPadding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: HarpyListCard(
          color: Colors.transparent,
          border: Border.all(color: theme.dividerColor),
          title: const Text('clear selection'),
          onTap: () {
            HapticFeedback.lightImpact();
            cubit.removeTimelineFilterSelection();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class _ToggleUniqueFilterCard extends StatelessWidget {
  const _ToggleUniqueFilterCard({
    required this.isUnique,
    required this.uniqueName,
  });

  final bool isUnique;
  final String uniqueName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: kBorderRadius,
          ),
          child: HarpySwitchTile(
            borderRadius: kBorderRadius,
            value: isUnique,
            title: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'only for '),
                  TextSpan(
                    text: uniqueName,
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              cubit.toggleUnique(value);
            },
          ),
        ),
      ),
    );
  }
}

class _AddNewFilterCard extends StatelessWidget {
  const _AddNewFilterCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return SliverPadding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: HarpyListCard(
          color: Colors.transparent,
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add new filter'),
          border: Border.all(color: theme.dividerColor),
          onTap: () => _openFilterCreation(context, cubit),
        ),
      ),
    );
  }
}

class _AddNewFilterButton extends StatelessWidget {
  const _AddNewFilterButton();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: HarpyButton.flat(
          padding: config.edgeInsets,
          icon: const Icon(CupertinoIcons.add),
          text: const Text('add new filter'),
          onTap: () => _openFilterCreation(context, cubit),
        ),
      ),
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
