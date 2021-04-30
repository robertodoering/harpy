import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ShowListsScreen extends StatelessWidget {
  const ShowListsScreen({
    @required this.userId,
    this.onListSelected,
  });

  final String userId;

  /// An optional callback that is called when a list is selected.
  ///
  /// When `null`, the list timeline screen will be navigated to.
  final ValueChanged<TwitterListData> onListSelected;

  static const String route = 'show_lists_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListsShowBloc>(
      create: (_) => ListsShowBloc(userId: userId),
      child: HarpyScaffold(
        body: ScrollDirectionListener(
          child: ScrollToStart(
            child: TwitterLists(
              onListSelected: onListSelected,
            ),
          ),
        ),
      ),
    );
  }
}
