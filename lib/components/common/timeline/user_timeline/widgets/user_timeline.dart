import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserTimelineCubit>();

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: const PageStorageKey('user_timeline'),
        beginSlivers: [_TopRow(user: user)],
        onChangeFilter: () => _openUserTimelineFilterSelection(
          context,
          user: user,
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            const _RefreshButton(),
            const Spacer(),
            _FilterButton(user: user),
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
    final cubit = context.watch<UserTimelineCubit>();
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

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final timelineCubit = context.watch<UserTimelineCubit>();
    final timelineState = timelineCubit.state;

    final filterCubit = context.watch<TimelineFilterCubit>();
    final filterState = filterCubit.state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: filterState.userFilter(user.id) != null
          ? Icon(
              Icons.filter_alt,
              color: timelineState.hasTweets
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(.5),
            )
          : const Icon(Icons.filter_alt_outlined),
      onTap: timelineState.hasTweets
          ? () => _openUserTimelineFilterSelection(context, user: user)
          : null,
    );
  }
}

void _openUserTimelineFilterSelection(
  BuildContext context, {
  required UserData user,
}) {
  Navigator.of(context).push(
    HarpyPageRoute<void>(
      builder: (_) => TimelineFilterSelection(
        blocBuilder: (context) => UserTimelineFilterCubit(
          timelineFilterCubit: context.read(),
          user: user,
        ),
      ),
      fullscreenDialog: true,
    ),
  );
}
