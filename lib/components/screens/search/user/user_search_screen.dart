import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen();

  static const route = 'user_search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSearchCubit>(
      create: (_) => UserSearchCubit(),
      child: const HarpyScaffold(
        body: UserSearchList(),
      ),
    );
  }
}
