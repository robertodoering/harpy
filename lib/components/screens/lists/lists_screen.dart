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
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return BlocProvider<ListsBloc>(
      create: (_) => ListsBloc(userId: userId)..add(ShowLists(userId: userId)),
      child: HarpyScaffold(
        body: ScrollDirectionListener(
          child: ScrollToStart(
            child: CustomScrollView(
              slivers: <Widget>[
                const HarpySliverAppBar(title: 'lists', floating: true),
                const TwitterListList(),
                SliverToBoxAdapter(
                  child: SizedBox(height: mediaQuery.padding.bottom),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
