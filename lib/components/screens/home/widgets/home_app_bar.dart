import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
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
      HarpyButton.flat(
        padding: const EdgeInsets.all(16),
        icon: bloc.state.enableFilter &&
                bloc.state.timelineFilter != TimelineFilter.empty
            ? Icon(Icons.filter_alt, color: theme.accentColor)
            : const Icon(Icons.filter_alt_outlined),
        onTap:
            bloc.state.enableFilter ? Scaffold.of(context).openEndDrawer : null,
      ),
      CustomPopupMenuButton<int>(
        padding: const EdgeInsets.all(16),
        icon: const Icon(Icons.more_vert),
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
