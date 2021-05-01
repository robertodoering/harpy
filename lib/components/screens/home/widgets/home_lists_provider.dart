import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds all the [ListTimelineBloc]s for the [model.listEntries].
///
/// The blocs are exposed via the [blocOf] method to get the bloc
/// corresponding to the list's id.
///
/// The blocs are closed automatically when no longer needed.
///
/// We don't use providers for every [ListTimeline] in the [HomeTabView]
/// because the views are disposed when not in view so every bloc would get
/// re-created when the list timeline comes into view.
/// Therefore we need to create the blocs above the tab view and since we
/// have multiple widgets that require the same type of bloc we need a
/// way to differentiate the blocs by their list id.
class HomeListsProvider extends StatefulWidget {
  const HomeListsProvider({
    @required this.model,
    @required this.child,
  });

  final HomeTabModel model;
  final Widget child;

  /// Returns the [ListTimelineBloc] for the bloc with the matching [listId].
  static ListTimelineBloc blocOf(
    BuildContext context, {
    @required String listId,
  }) {
    return _HomeListsBlocsScope.of(context).blocs.firstWhere(
          (ListTimelineBloc bloc) => bloc.listId == listId,
          orElse: () => null,
        );
  }

  @override
  _HomeListsProviderState createState() => _HomeListsProviderState();
}

class _HomeListsProviderState extends State<HomeListsProvider> {
  List<ListTimelineBloc> blocs = <ListTimelineBloc>[];

  /// Every bloc in [blocs] that does not have a matching entry anymore and
  /// should be closed.
  List<ListTimelineBloc> get _unusedBlocs => blocs.where(_hasNoEntry).toList();

  /// Every bloc in [blocs] that has a matching entry and should be kept.
  List<ListTimelineBloc> get _usedBlocs => blocs.where(_hasEntry).toList();

  /// Every new entry that should get a bloc.
  List<HomeTabEntry> get _newEntries =>
      widget.model.listEntries.where(_hasNoBloc).toList();

  @override
  void initState() {
    super.initState();
    _createBlocs(widget.model.listEntries);
  }

  @override
  void didUpdateWidget(covariant HomeListsProvider oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (ListTimelineBloc bloc in _unusedBlocs) {
      bloc.close();
    }

    blocs = _usedBlocs;
    _createBlocs(_newEntries);
  }

  void _createBlocs(List<HomeTabEntry> entries) {
    for (HomeTabEntry entry in entries) {
      blocs.add(ListTimelineBloc(listId: entry.id));
    }
  }

  bool _hasEntry(ListTimelineBloc bloc) {
    for (HomeTabEntry entry in widget.model.listEntries) {
      if (entry.id == bloc.listId) {
        return true;
      }
    }

    return false;
  }

  bool _hasNoEntry(ListTimelineBloc bloc) {
    return !_hasEntry(bloc);
  }

  bool _hasNoBloc(HomeTabEntry entry) {
    for (ListTimelineBloc bloc in blocs) {
      if (bloc.listId == entry.id) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();

    for (ListTimelineBloc bloc in blocs) {
      bloc.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (blocs.isNotEmpty) {
      return _HomeListsBlocsScope(
        blocs: blocs,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}

/// Exposes the [_HomeListsBlocsScope.blocs] to the widget tree.
class _HomeListsBlocsScope extends InheritedWidget {
  const _HomeListsBlocsScope({
    Key key,
    @required this.blocs,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final List<ListTimelineBloc> blocs;

  static _HomeListsBlocsScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HomeListsBlocsScope>();
  }

  @override
  bool updateShouldNotify(_HomeListsBlocsScope old) {
    return !listEquals(blocs, old.blocs);
  }
}
