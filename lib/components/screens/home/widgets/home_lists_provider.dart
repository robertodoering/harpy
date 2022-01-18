import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
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
    return _HomeListsCubitsScope.of(context)!.cubits.firstWhereOrNull(
          (cubit) => cubit.listId == listId,
        );
  }

  @override
  _HomeListsProviderState createState() => _HomeListsProviderState();
}

class _HomeListsProviderState extends State<HomeListsProvider> {
  List<ListTimelineCubit> cubits = [];

  /// Every cubit in [cubits] that does not have a matching entry anymore and
  /// should be closed.
  List<ListTimelineCubit> get _unusedCubits =>
      cubits.whereNot(_hasEntry).toList();

  /// Every cubit in [cubits] that has a matching entry and should be kept.
  List<ListTimelineCubit> get _usedCubits => cubits.where(_hasEntry).toList();

  /// Every new entry that should get a cubit.
  List<HomeTabEntry> get _newEntries =>
      widget.model.listEntries.where(_hasNocubit).toList();

  @override
  void initState() {
    super.initState();
    _createCubits(widget.model.listEntries);
  }

  @override
  void didUpdateWidget(covariant HomeListsProvider oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final cubit in _unusedCubits) {
      cubit.close();
    }

    cubits = _usedCubits;
    _createCubits(_newEntries);
  }

  void _createCubits(List<HomeTabEntry> entries) {
    for (final entry in entries) {
      cubits.add(
        ListTimelineCubit(
          timelineFilterCubit: context.read(),
          listId: entry.id,
        ),
      );
    }
  }

  bool _hasEntry(ListTimelineCubit cubit) {
    for (final entry in widget.model.listEntries) {
      if (entry.id == cubit.listId) {
        return true;
      }
    }

    return false;
  }

  bool _hasNocubit(HomeTabEntry entry) {
    for (final cubit in cubits) {
      if (cubit.listId == entry.id) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    for (final cubit in cubits) {
      cubit.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cubits.isNotEmpty) {
      return _HomeListsCubitsScope(
        cubits: cubits,
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

  final List<ListTimelineCubit> cubits;

  static _HomeListsCubitsScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HomeListsCubitsScope>();
  }

  @override
  bool updateShouldNotify(_HomeListsCubitsScope old) {
    return !listEquals(cubits, old.cubits);
  }
}
