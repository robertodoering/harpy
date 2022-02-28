import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TimelineFilterSelection extends ConsumerStatefulWidget {
  const TimelineFilterSelection({
    required this.provider,
  });

  final StateNotifierProviderOverrideMixin<TimelineFilterSelectionNotifier,
      TimelineFilterSelectionState> provider;

  @override
  _TimelineFilterSelectionState createState() =>
      _TimelineFilterSelectionState();
}

class _TimelineFilterSelectionState
    extends ConsumerState<TimelineFilterSelection> with RouteAware {
  RouteObserver? _observer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(widget.provider.notifier).sortTimelineFilters();
    });
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  void _openFilterCreation(TimelineFilterSelectionNotifier notifier) {
    ref.read(routerProvider).pushNamed(
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
          const HarpySliverAppBar(title: 'settings'),
          sliverVerticalSpacer,
          ...?state.mapOrNull(
            noFilters: (_) => [
              _AddNewFilterFillSliver(
                onTap: () => _openFilterCreation(notifier),
              ),
            ],
            data: (data) => [
              if (data.activeFilter != null) ...[
                _ClearFilterCard(onTap: notifier.removeTimelineFilterSelection),
                sliverVerticalSpacer,
              ],
              if (data.showUnique && data.uniqueName != null) ...[
                _ToggleUniqueFilterCard(
                  isUnique: data.isUnique,
                  uniqueName: data.uniqueName!,
                  onChanged: notifier.toggleUnique,
                ),
                sliverVerticalSpacer,
              ],
              _TimelineFilterList(
                notifier: notifier,
                sortedFilters: data.sortedFilters,
              ),
              sliverVerticalSpacer,
              _AddNewFilterCard(onTap: () => _openFilterCreation(notifier)),
            ],
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _TimelineFilterList extends ConsumerWidget {
  const _TimelineFilterList({
    required this.notifier,
    required this.sortedFilters,
  });

  final TimelineFilterSelectionNotifier notifier;
  final BuiltList<SortedTimelineFilter> sortedFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => index.isEven
              ? TimelineFilterCard(
                  notifier: notifier,
                  sortedFilter: sortedFilters[index ~/ 2],
                )
              : verticalSpacer,
          childCount: sortedFilters.length * 2 - 1,
        ),
      ),
    );
  }
}

class _ClearFilterCard extends ConsumerWidget {
  const _ClearFilterCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: HarpyListCard(
          color: Colors.transparent,
          border: Border.all(color: theme.dividerColor),
          title: const Text('clear selection'),
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

class _ToggleUniqueFilterCard extends ConsumerWidget {
  const _ToggleUniqueFilterCard({
    required this.isUnique,
    required this.uniqueName,
    required this.onChanged,
  });

  final bool isUnique;
  final String uniqueName;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: display.edgeInsetsSymmetric(horizontal: true),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: harpyTheme.borderRadius,
          ),
          child: HarpySwitchTile(
            borderRadius: harpyTheme.borderRadius,
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

class _AddNewFilterCard extends ConsumerWidget {
  const _AddNewFilterCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return SliverPadding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
      sliver: SliverToBoxAdapter(
        child: HarpyListCard(
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

class _AddNewFilterFillSliver extends ConsumerWidget {
  const _AddNewFilterFillSliver({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: HarpyButton.icon(
          icon: const Icon(CupertinoIcons.add),
          label: const Text('add new filter'),
          onTap: onTap,
        ),
      ),
    );
  }
}
