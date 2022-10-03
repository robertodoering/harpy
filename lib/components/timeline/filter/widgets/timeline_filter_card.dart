import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TimelineFilterCard extends ConsumerWidget {
  const TimelineFilterCard({
    required this.notifier,
    required this.sortedFilter,
  });

  final TimelineFilterSelectionNotifier notifier;
  final SortedTimelineFilter sortedFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return _TimelineFilterCardBase(
      isSelected: sortedFilter.isSelected,
      onTap: sortedFilter.isSelected
          ? () => ref.read(routerProvider).pushNamed(
                TimelineFilterCreation.name,
                extra: {'initialTimelineFilter': sortedFilter.timelineFilter},
              )
          : () {
              HapticFeedback.lightImpact();
              notifier.selectTimelineFilter(sortedFilter.timelineFilter.uuid);
              Navigator.of(context).pop();
            },
      onLongPress: () => _showTimelineFilterCardBottomSheet(
        ref,
        filter: sortedFilter.timelineFilter,
        notifier: notifier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: display.edgeInsets.copyWith(bottom: 0),
                  child: Text(
                    sortedFilter.timelineFilter.name,
                    style: theme.textTheme.subtitle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (sortedFilter.appliedFilters.isNotEmpty) ...[
                  Padding(
                    padding: display.edgeInsets.copyWith(top: 0),
                    child: _AppliedFiltersText(
                      filters: sortedFilter.appliedFilters,
                    ),
                  ),
                ] else
                  verticalSpacer,
              ],
            ),
          ),
          HarpyButton.icon(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            onTap: () => _showTimelineFilterCardBottomSheet(
              ref,
              filter: sortedFilter.timelineFilter,
              notifier: notifier,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineFilterCardBase extends ConsumerWidget {
  const _TimelineFilterCardBase({
    required this.child,
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: harpyTheme.borderRadius,
        color: theme.cardTheme.color,
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: harpyTheme.borderRadius,
          onTap: onTap,
          onLongPress: onLongPress,
          child: child,
        ),
      ),
    );
  }
}

class _AppliedFiltersText extends StatelessWidget {
  const _AppliedFiltersText({
    required this.filters,
  });

  final Iterable<ActiveTimelineFilter> filters;

  String _textFromFilter(ActiveTimelineFilter filter) {
    if (filter.data != null) {
      return filter.data!.map(
        user: (data) => '@${data.handle}',
        list: (data) => data.name,
      );
    } else {
      switch (filter.type) {
        case TimelineFilterType.home:
          return 'home timeline';
        case TimelineFilterType.user:
          return 'user timeline';
        case TimelineFilterType.list:
          return 'list timeline';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.caption?.copyWith(
      color: theme.colorScheme.secondary,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'used for ', style: theme.textTheme.caption),
          for (final filter in filters) ...[
            TextSpan(
              text: _textFromFilter(filter),
              style: style,
            ),
            if (filter != filters.last) TextSpan(text: ', ', style: style),
          ]
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

void _showTimelineFilterCardBottomSheet(
  WidgetRef ref, {
  required TimelineFilter filter,
  required TimelineFilterSelectionNotifier notifier,
}) {
  final theme = Theme.of(ref.context);

  showHarpyBottomSheet<void>(
    ref.context,
    harpyTheme: ref.read(harpyThemeProvider),
    children: [
      BottomSheetHeader(
        child: Text(
          filter.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      HarpyListTile(
        leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
        title: Text(
          'delete',
          style: TextStyle(
            color: theme.errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          HapticFeedback.lightImpact();

          ref
              .read(timelineFilterProvider.notifier)
              .removeTimelineFilter(filter.uuid);
          notifier.sortTimelineFilters();

          Navigator.of(ref.context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(FeatherIcons.edit2),
        title: const Text('edit'),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(ref.context).pop();

          ref.read(routerProvider).pushNamed(
            TimelineFilterCreation.name,
            extra: {'initialTimelineFilter': filter},
          );
        },
      ),
      HarpyListTile(
        leading: const Icon(FeatherIcons.copy),
        title: const Text('duplicate'),
        onTap: () {
          HapticFeedback.lightImpact();

          ref
              .read(timelineFilterProvider.notifier)
              .duplicateTimelineFilter(filter.uuid);
          notifier.sortTimelineFilters();

          Navigator.of(ref.context).pop();
        },
      ),
    ],
  );
}
