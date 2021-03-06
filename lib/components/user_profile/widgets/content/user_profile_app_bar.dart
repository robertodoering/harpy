import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      IconButton(
        icon: timelineBloc.state.enableFilter &&
                timelineBloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.accentColor)
            : const Icon(Icons.filter_alt_outlined),
        onPressed: timelineBloc.state.enableFilter
            ? Scaffold.of(context).openEndDrawer
            : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UserProfileBloc profileBloc = context.watch<UserProfileBloc>();
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();
    final UserTimelineBloc timelineBloc = context.watch<UserTimelineBloc>();

    final bool _hasUser = profileBloc.state is InitializedUserState ||
        profileBloc.state is TranslatingDescriptionState;

    // todo: back arrow disappears with custom actions

    return HarpySliverAppBar(
      title: profileBloc.user?.name ?? '',
      stretch: true,
      pinned: true,
      actions: _buildActions(context, theme, model, timelineBloc),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: Navigator.of(context).pop,
      ),
      background: _hasUser ? UserBanner(profileBloc) : null,
    );
  }
}
