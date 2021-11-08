import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final expandedHeight = min<double>(200, mediaQuery.size.height * .25);

    return SliverAppBar(
      centerTitle: true,
      elevation: 0,
      pinned: true,
      backgroundColor: Colors.transparent,
      expandedHeight: user.hasBanner ? expandedHeight : 0,
      flexibleSpace: user.hasBanner
          ? FlexibleSpaceBar(background: UserBanner(user: user))
          : null,
      leading: const _BackButton(),
      actions: const [_FilterButton()],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: HarpyButton.raised(
        backgroundColor: theme.canvasColor.withOpacity(.4),
        elevation: 0,
        padding: const EdgeInsets.all(12),
        icon: const Icon(CupertinoIcons.left_chevron),
        onTap: Navigator.of(context).pop,
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timelineBloc = context.watch<UserTimelineBloc>();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: HarpyButton.raised(
        backgroundColor: theme.canvasColor.withOpacity(.4),
        elevation: 0,
        padding: const EdgeInsets.all(12),
        icon: timelineBloc.state.enableFilter &&
                timelineBloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.colorScheme.secondary)
            : const Icon(Icons.filter_alt_outlined),
        onTap: timelineBloc.state.enableFilter
            ? Scaffold.of(context).openEndDrawer
            : null,
      ),
    );
  }
}
