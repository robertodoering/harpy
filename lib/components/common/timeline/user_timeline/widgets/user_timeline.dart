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
    final state = cubit.state;

    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: const PageStorageKey('user_timeline'),
        beginSlivers: [
          if (state.hasTweets) _TopRow(user: user),
        ],
        onChangeFilter: () => _openUserTimelineFilterSelection(
          context,
          user: user,
        ),
        beginActionCount: 1,
        endActionCount: 1,
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

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: const Icon(CupertinoIcons.refresh),
      onTap: () => cubit.load(clearPrevious: true),
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

    final cubit = context.watch<TimelineFilterCubit>();
    final state = cubit.state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: state.userFilter(user.id) != null
          ? Icon(Icons.filter_alt, color: theme.colorScheme.primary)
          : const Icon(Icons.filter_alt_outlined),
      onTap: () => _openUserTimelineFilterSelection(context, user: user),
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
