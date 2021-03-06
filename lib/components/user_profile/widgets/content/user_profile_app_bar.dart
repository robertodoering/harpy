import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/components/user_profile/widgets/content/user_banner.dart';
import 'package:provider/provider.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar();

  List<Widget> _buildActions(
    BuildContext context,
    ThemeData theme,
    TimelineFilterModel model,
    UserTimelineBloc timelineBloc,
  ) {
    return <Widget>[
      _buildButton(
        theme,
        timelineBloc.state.enableFilter &&
                timelineBloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.accentColor)
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

  Widget _buildButton(ThemeData theme, Widget icon, VoidCallback onTap) {
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
    final ThemeData theme = Theme.of(context);
    final UserProfileBloc profileBloc = context.watch<UserProfileBloc>();
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();
    final UserTimelineBloc timelineBloc = context.watch<UserTimelineBloc>();

    final bool _hasUser = profileBloc.state is InitializedUserState ||
        profileBloc.state is TranslatingDescriptionState;

    return HarpySliverAppBar(
      title: profileBloc.user?.name ?? '',
      stretch: true,
      pinned: true,
      leading: _buildLeading(context, theme),
      actions: _buildActions(context, theme, model, timelineBloc),
      background: _hasUser ? UserBanner(profileBloc) : null,
    );
  }
}
