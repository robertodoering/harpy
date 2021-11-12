import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of members for the specified twitter list.
class ListMembersScreen extends StatelessWidget {
  const ListMembersScreen({
    required this.listId,
    this.name,
  });

  final String listId;
  final String? name;

  static const route = 'list_members';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginatedUsersCubit>(
      create: (_) => ListMembersCubit(listId: listId),
      child: PaginatedUsersScreen(
        title: name != null ? '$name members' : 'members',
        errorMessage: 'error loading list members',
        noDataMessage: 'no members found',
      ),
    );
  }
}
