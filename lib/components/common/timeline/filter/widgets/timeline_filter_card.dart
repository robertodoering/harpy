import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TimelineFilterCard extends StatelessWidget {
  const TimelineFilterCard({
    required this.sortedFilter,
  });

  final SortedTimelineFilter sortedFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TimelineFilterSelectionCubit>();

    return _TimelineFilterCardBase(
      isSelected: sortedFilter.isSelected,
      onTap: sortedFilter.isSelected
          ? () => _openFilterCreation(
                context,
                cubit: cubit,
                filter: sortedFilter.timelineFilter,
              )
          : () {
              HapticFeedback.lightImpact();
              cubit.selectTimelineFilter(sortedFilter.timelineFilter.uuid);
              Navigator.of(context).pop();
            },
      onLongPress: () => _showTimelineFilterCardBottomSheet(
        context,
        filter: sortedFilter.timelineFilter,
        cubit: cubit,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: config.edgeInsets.copyWith(bottom: 0),
                  child: Text(
                    sortedFilter.timelineFilter.name,
                    style: theme.textTheme.subtitle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (sortedFilter.appliedFilters.isNotEmpty) ...[
                  Padding(
                    padding: config.edgeInsets.copyWith(top: 0),
                    child: _AppliedFiltersText(
                      filters: sortedFilter.appliedFilters,
                    ),
                  ),
                ] else
                  verticalSpacer,
              ],
            ),
          ),
          HarpyButton.flat(
            padding: config.edgeInsets,
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            onTap: () => _showTimelineFilterCardBottomSheet(
              context,
              filter: sortedFilter.timelineFilter,
              cubit: cubit,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineFilterCardBase extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        color: theme.cardTheme.color,
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: kBorderRadius,
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
  BuildContext context, {
  required TimelineFilter filter,
  required TimelineFilterSelectionCubit cubit,
}) {
  final theme = Theme.of(context);

  showHarpyBottomSheet<void>(
    context,
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

          context.read<TimelineFilterCubit>().removeTimelineFilter(filter.uuid);
          cubit.sortTimelineFilters();

          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(FeatherIcons.edit2),
        title: const Text('edit'),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();

          _openFilterCreation(
            context,
            cubit: cubit,
            filter: filter,
          );
        },
      ),
      HarpyListTile(
        leading: const Icon(FeatherIcons.copy),
        title: const Text('duplicate'),
        onTap: () {
          HapticFeedback.lightImpact();

          context
              .read<TimelineFilterCubit>()
              .duplicateTimelineFilter(filter.uuid);
          cubit.sortTimelineFilters();

          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Future<void> _openFilterCreation(
  BuildContext context, {
  required TimelineFilterSelectionCubit cubit,
  required TimelineFilter filter,
}) async {
  await Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => TimelineFilterCreation(timelineFilter: filter),
    ),
  );

  cubit.sortTimelineFilters();
}
