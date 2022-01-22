import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Shows a [ListTimeline] for the [listId] in its own screen.
class ListTimelineScreen extends StatelessWidget {
  const ListTimelineScreen({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  static const route = 'list_timeline';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocProvider(
      create: (context) => ListTimelineCubit(
        timelineFilterCubit: context.read(),
        listId: listId,
      ),
      child: HarpyScaffold(
        body: ScrollDirectionListener(
          child: ListTimeline(
            listName: listName,
            beginSlivers: [
              HarpySliverAppBar(title: listName, floating: true),
            ],
            refreshIndicatorOffset: -mediaQuery.padding.top,
          ),
        ),
      ),
    );
  }
}
