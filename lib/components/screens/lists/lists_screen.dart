import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({
    @required this.userId,
  });

  final String userId;

  static const String route = 'lists_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShowListsBloc>(
      create: (_) => ShowListsBloc(userId: userId),
      child: HarpyScaffold(
        body: ScrollDirectionListener(
          child: ScrollToStart(
            child: BlocListener<ShowListsBloc, ShowListsState>(
              listener: (BuildContext context, _) {
                // ScrollDirection.of(context).reset();
              },
              child: const TwitterLists(),
            ),
          ),
        ),
      ),
    );
  }
}
