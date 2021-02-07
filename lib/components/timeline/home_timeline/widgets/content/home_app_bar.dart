import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_sliver_app_bar.dart';
import 'package:harpy/components/timeline/new/home_timeline/bloc/home_timeline_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  List<Widget> _buildActions() {
    return <Widget>[
      Builder(
        builder: (BuildContext context) => PopupMenuButton<int>(
          onSelected: (int selection) {
            if (selection == 0) {
              context
                  .read<NewHomeTimelineBloc>()
                  .add(const RefreshHomeTimeline(clearPrevious: true));
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(value: 0, child: Text('refresh')),
            ];
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpySliverAppBar(
      title: 'Harpy',
      showIcon: true,
      floating: true,
      actions: _buildActions(),
    );
  }
}
