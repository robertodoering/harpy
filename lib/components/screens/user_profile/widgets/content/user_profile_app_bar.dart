import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar();

  List<Widget> _buildActions(
    BuildContext context,
    ThemeData theme,
    TimelineFilterModel model,
    UserTimelineBloc timelineBloc,
  ) {
    return [
      _buildButton(
        theme,
        timelineBloc.state.enableFilter &&
                timelineBloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.colorScheme.secondary)
            : const Icon(Icons.filter_alt_outlined),
        timelineBloc.state.enableFilter
            ? Scaffold.of(context).openEndDrawer
            : null,
      ),
    ];
  }

  Widget _buildLeading(BuildContext context, ThemeData theme) {
    return _buildButton(
      theme,
      Transform.translate(
        offset: const Offset(-1, 0),
        child: const Icon(CupertinoIcons.left_chevron),
      ),
      Navigator.of(context).pop,
    );
  }

  Widget _buildButton(ThemeData theme, Widget icon, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: HarpyButton.raised(
        backgroundColor: theme.canvasColor.withOpacity(.4),
        elevation: 0,
        padding: const EdgeInsets.all(12),
        icon: icon,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final profileBloc = context.watch<UserProfileBloc>();
    final model = context.watch<TimelineFilterModel>();
    final timelineBloc = context.watch<UserTimelineBloc>();

    final _hasUser = profileBloc.state is InitializedUserState ||
        profileBloc.state is TranslatingDescriptionState;

    final expandedHeight = min<double>(200, mediaQuery.size.height * .25);

    return SliverAppBar(
      centerTitle: true,
      elevation: 0,
      pinned: true,
      backgroundColor: Colors.transparent,
      expandedHeight: expandedHeight,
      flexibleSpace: _hasUser
          ? FlexibleSpaceBar(background: UserBanner(profileBloc))
          : null,
      leading: _buildLeading(context, theme),
      actions: _buildActions(context, theme, model, timelineBloc),
    );
  }
}
