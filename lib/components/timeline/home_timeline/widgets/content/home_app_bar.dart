import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/filter/filter_check_box.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/common/misc/harpy_popup_menu_item.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/search/widgets/search_screen.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.filter_alt_outlined),
        onPressed: Scaffold.of(context).openEndDrawer,
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
            context
                .read<HomeTimelineBloc>()
                .add(const RefreshHomeTimeline(clearPrevious: true));
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
    return HarpySliverAppBar(
      title: 'Harpy',
      showIcon: true,
      floating: true,
      actions: _buildActions(context),
    );
  }
}

class HomeTimelineFilterDrawer extends StatelessWidget {
  const HomeTimelineFilterDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: HarpyBackground(
        child: ListView(
          children: [
            FilterCheckBox(
              text: 'hide retweets',
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
