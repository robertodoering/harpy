import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/widgets/content/user_search_list.dart';

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
