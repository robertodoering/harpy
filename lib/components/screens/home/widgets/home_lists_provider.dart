import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds all the [ListTimelineCubit]s for the [HomeTabModel.listEntries].
///
/// The cubits are exposed via the [cubitOf] method to get the cubit
/// corresponding to the list's id.
///
/// The cubits are closed automatically when no longer needed.
///
/// We don't use providers for every [ListTimeline] in the [HomeTabView]
/// because the views are disposed when not in view so every cubit would get
/// re-created when the list timeline comes into view.
/// Therefore we need to create the cubits above the tab view and since we
/// have multiple widgets that require the same type of cubit we need a
/// way to differentiate the cubits by their list id.
class HomeListsProvider extends StatefulWidget {
  const HomeListsProvider({
    required this.model,
    required this.child,
  });

  final HomeTabModel model;
  final Widget child;

  /// Returns the [ListTimelineCubit] for the cubit with the matching [listId].
  static ListTimelineCubit? cubitOf(
    BuildContext context, {
    required String? listId,
  }) {
    return _HomeListsCubitsScope.of(context)?.cubits.firstWhereOrNull(
          (cubit) => cubit.listId == listId,
        );
  }

  @override
  _HomeListsProviderState createState() => _HomeListsProviderState();
}

class _HomeListsProviderState extends State<HomeListsProvider> {
  List<ListTimelineCubit> _cubits = [];

  /// Every cubit in [_cubits] that does not have a matching entry anymore and
  /// should be closed.
  Iterable<ListTimelineCubit> get _unusedCubits => _cubits.whereNot(_hasEntry);

  /// Every cubit in [_cubits] that has a matching entry and should be kept.
  Iterable<ListTimelineCubit> get _usedCubits => _cubits.where(_hasEntry);

  /// Every new entry that should get a cubit.
  Iterable<HomeTabEntry> get _newEntries =>
      widget.model.listEntries.where(_hasNocubit);

  bool _hasEntry(ListTimelineCubit cubit) =>
      !widget.model.listEntries.any((entry) => entry.id == cubit.listId);

  bool _hasNocubit(HomeTabEntry entry) =>
      !_cubits.any((cubit) => cubit.listId == entry.id);

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_homeTabCubitListener);

    _createCubits(widget.model.listEntries);
  }

  @override
  void dispose() {
    widget.model.removeListener(_homeTabCubitListener);

    for (final cubit in _cubits) {
      cubit.close();
    }

    super.dispose();
  }

  void _homeTabCubitListener() {
    for (final cubit in _unusedCubits) {
      cubit.close();
    }

    _cubits = _usedCubits.toList();
    _createCubits(_newEntries);

    if (mounted) {
      // rebuild inherited widget with new cubits
      setState(() {});
    }
  }

  void _createCubits(Iterable<HomeTabEntry> entries) {
    for (final entry in entries) {
      _cubits.add(
        ListTimelineCubit(
          timelineFilterCubit: context.read(),
          listId: entry.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cubits.isNotEmpty) {
      return _HomeListsCubitsScope(
        cubits: _cubits.toBuiltList(),
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}

/// Exposes the [_HomeListsCubitsScope.cubits] to the widget tree.
class _HomeListsCubitsScope extends InheritedWidget {
  const _HomeListsCubitsScope({
    required this.cubits,
    required Widget child,
  }) : super(child: child);

  final BuiltList<ListTimelineCubit> cubits;

  static _HomeListsCubitsScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HomeListsCubitsScope>();
  }

  @override
  bool updateShouldNotify(_HomeListsCubitsScope old) {
    return cubits != old.cubits;
  }
}
