import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class ListTimelinePage extends StatelessWidget {
  const ListTimelinePage({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  static const name = 'list_timeline';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: ListTimeline(
            listId: listId,
            listName: listName,
            beginSlivers: [HarpySliverAppBar(title: Text(listName))],
          ),
        ),
      ),
    );
  }
}
