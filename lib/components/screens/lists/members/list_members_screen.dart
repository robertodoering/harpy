import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ListMembersScreen extends StatelessWidget {
  const ListMembersScreen({
    required this.list,
  });

  final TwitterListData list;

  static const route = 'list_members_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListMembersCubit(list: list),
      child: HarpyScaffold(
        body: TwitterListMembers(
          list: list,
        ),
      ),
    );
  }
}
