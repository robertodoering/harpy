import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Wraps the [ListTimeline] with a [ListTimelineBloc] and keeps it's state
/// when switching tabs.
class ListTimelineProvider extends StatefulWidget {
  const ListTimelineProvider({
    @required this.listId,
  });

  final String listId;

  @override
  _ListTimelineProviderState createState() => _ListTimelineProviderState();
}

class _ListTimelineProviderState extends State<ListTimelineProvider>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider<ListTimelineBloc>(
      create: (_) => ListTimelineBloc(listId: widget.listId),
      child: ListTimeline(listId: widget.listId),
    );
  }
}
