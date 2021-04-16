import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class TwitterListsScreen extends StatelessWidget {
  const TwitterListsScreen({
    @required this.userId,
  });

  final String userId;

  static const String route = 'twitter_lists_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListsShowBloc>(
      create: (_) => ListsShowBloc(userId: userId),
      child: const HarpyScaffold(
        body: ScrollDirectionListener(
          child: ScrollToStart(
            child: TwitterLists(),
          ),
        ),
      ),
    );
  }
}
