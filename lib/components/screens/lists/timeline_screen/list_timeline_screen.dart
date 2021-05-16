import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Shows a [ListTimeline] for the [list] in it's own screen.
class ListTimelineScreen extends StatelessWidget {
  const ListTimelineScreen({
    required this.list,
  });

  final TwitterListData list;

  static const String route = 'list_timeline_screen';

  Widget _buildActionsButton(BuildContext context) {
    return CustomPopupMenuButton<void>(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      onSelected: (_) =>
          app<HarpyNavigator>().pushListMembersScreen(list: list),
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          const HarpyPopupMenuItem<int>(
            value: 0,
            text: Text('show members'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListTimelineBloc>(
      create: (_) => ListTimelineBloc(listId: list.idStr),
      child: HarpyScaffold(
        body: ScrollDirectionListener(
          child: ScrollToStart(
            child: ListTimeline(
              listId: list.idStr,
              beginSlivers: <Widget>[
                HarpySliverAppBar(
                  title: list.name,
                  floating: true,
                  actions: [
                    _buildActionsButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
