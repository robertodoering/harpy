import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class TimelineFilterSelection extends ConsumerStatefulWidget {
  const TimelineFilterSelection({
    required this.provider,
  });

  final AutoDisposeStateNotifierProvider<TimelineFilterSelectionNotifier,
      TimelineFilterSelectionState> provider;

  @override
  ConsumerState<TimelineFilterSelection> createState() =>
      _TimelineFilterSelectionState();
}

class _TimelineFilterSelectionState
    extends ConsumerState<TimelineFilterSelection> with RouteAware {
  RouteObserver? _observer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widget.provider.notifier).sortTimelineFilters();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _observer ??= ref.read(routeObserver)
      ?..subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widget.provider.notifier).sortTimelineFilters();
    });
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  void _openFilterCreation(TimelineFilterSelectionNotifier notifier) {
    context.pushNamed(
      TimelineFilterCreation.name,
      extra: {
        // ignore: avoid_types_on_closure_parameters
        'onSaved': (TimelineFilter filter) =>
            notifier.selectTimelineFilter(filter.uuid),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final notifier = ref.watch(widget.provider.notifier);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('timeline filter')),
          VerticalSpacer.normalSliver,
          ...?state.mapOrNull(
            noFilters: (_) => [
              _AddNewFilterFillSliver(
                onTap: () => _openFilterCreation(notifier),
              ),
            ],
            data: (data) => [
              if (data.activeFilter != null) ...[
                _ClearFilterCard(onTap: notifier.removeTimelineFilterSelection),
                VerticalSpacer.normalSliver,
              ],
              if (data.showUnique && data.uniqueName != null) ...[
                _ToggleUniqueFilterCard(
                  isUnique: data.isUnique,
                  uniqueName: data.uniqueName!,
                  onChanged: notifier.toggleUnique,
                ),
                VerticalSpacer.normalSliver,
              ],
              _TimelineFilterList(
                notifier: notifier,
                sortedFilters: data.sortedFilters,
              ),
              VerticalSpacer.normalSliver,
              _AddNewFilterCard(onTap: () => _openFilterCreation(notifier)),
            ],
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _TimelineFilterList extends StatelessWidget {
  const _TimelineFilterList({
    required this.notifier,
    required this.sortedFilters,
  });

  final TimelineFilterSelectionNotifier notifier;
  final BuiltList<SortedTimelineFilter> sortedFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: theme.spacing.symmetric(horizontal: true),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => index.isEven
              ? TimelineFilterCard(
                  notifier: notifier,
                  sortedFilter: sortedFilters[index ~/ 2],
                )
              : VerticalSpacer.normal,
          childCount: sortedFilters.length * 2 - 1,
        ),
      ),
    );
  }
}

class _ClearFilterCard extends StatelessWidget {
  const _ClearFilterCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: theme.spacing.symmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: RbyListCard(
          color: Colors.transparent,
          border: Border.all(color: theme.dividerColor),
          title: const Text('remove filter'),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            onTap();
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
    required this.onChanged,
  });

  final bool isUnique;
  final String uniqueName;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: theme.spacing.symmetric(horizontal: true),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: theme.shape.borderRadius,
          ),
          child: RbySwitchTile(
            borderRadius: theme.shape.borderRadius,
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
              onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}

class _AddNewFilterCard extends StatelessWidget {
  const _AddNewFilterCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: theme.spacing.symmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: RbyListCard(
          color: Colors.transparent,
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add new filter'),
          border: Border.all(color: theme.dividerColor),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _AddNewFilterFillSliver extends StatelessWidget {
  const _AddNewFilterFillSliver({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: RbyButton.transparent(
          icon: const Icon(CupertinoIcons.add),
          label: const Text('add new filter'),
          onTap: onTap,
        ),
      ),
    );
  }
}
