import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_popup_menu_item.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/widgets/search_screen.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  List<Widget> _buildActions(
    BuildContext context,
    ThemeData theme,
    TimelineFilterModel model,
    HomeTimelineBloc bloc,
  ) {
    return <Widget>[
      IconButton(
        icon: bloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.accentColor)
            : const Icon(Icons.filter_alt_outlined),
        onPressed:
            bloc.state.enableFilter ? Scaffold.of(context).openEndDrawer : null,
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.search),
        onPressed: () => app<HarpyNavigator>().pushNamed(SearchScreen.route),
      ),
      PopupMenuButton<int>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (int selection) {
          if (selection == 0) {
            ScrollDirection.of(context).reset();

            bloc.add(const RefreshHomeTimeline(clearPrevious: true));
          }
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<int>>[
            const HarpyPopupMenuItem<int>(value: 0, text: Text('refresh')),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();
    final HomeTimelineBloc bloc = context.watch<HomeTimelineBloc>();

    return HarpySliverAppBar(
      title: 'Harpy',
      showIcon: true,
      floating: true,
      actions: _buildActions(context, theme, model, bloc),
    );
  }
}
