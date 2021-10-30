import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of members for the specified twitter [list].
class ListMembersScreen extends StatelessWidget {
  const ListMembersScreen({
    required this.list,
  });

  final TwitterListData list;

  static const route = 'list_members';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginatedUsersCubit>(
      create: (_) => ListMembersCubit(listId: list.idStr),
      child: PaginatedUsersScreen(
        title: '${list.name} members',
        errorMessage: 'error loading list members',
        noDataMessage: 'no members found',
      ),
    );
  }
}
