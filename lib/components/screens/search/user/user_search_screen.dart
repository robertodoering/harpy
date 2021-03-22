import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen();

  static const String route = 'user_search_screen';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      body: BlocProvider<UserSearchBloc>(
        create: (_) => UserSearchBloc(),
        child: const UserSearchList(),
      ),
    );
  }
}
