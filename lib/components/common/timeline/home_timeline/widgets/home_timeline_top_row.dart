import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Built as the begin sliver for the home timeline.
class HomeTimelineTopRow extends StatelessWidget {
  const HomeTimelineTopRow();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: const [
            _RefreshButton(),
            Spacer(),
            _ComposeButton(),
            horizontalSpacer,
            _FilterButton(),
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<HomeTimelineCubit>();
    final state = cubit.state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: const Icon(CupertinoIcons.refresh),
      onTap: state.hasTweets ? () => cubit.load(clearPrevious: true) : null,
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<HomeTimelineCubit>();
    final state = cubit.state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: const Icon(FeatherIcons.feather),
      onTap: state.hasTweets ? app<HarpyNavigator>().pushComposeScreen : null,
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final timelineCubit = context.watch<HomeTimelineCubit>();
    final timelineState = timelineCubit.state;

    final filterCubit = context.watch<TimelineFilterCubit>();
    final filterState = filterCubit.state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: filterState.homeFilter() != null
          ? Icon(
              Icons.filter_alt,
              color: timelineState.hasTweets
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(.5),
            )
          : const Icon(Icons.filter_alt_outlined),
      onTap: timelineState.hasTweets
          ? () => openHomeTimelineFilterSelection(context)
          : null,
    );
  }
}

void openHomeTimelineFilterSelection(BuildContext context) {
  Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => TimelineFilterSelection(
        blocBuilder: (context) => HomeTimelineFilterCubit(
          timelineFilterCubit: context.read(),
        ),
      ),
      fullscreenDialog: true,
    ),
  );
}
