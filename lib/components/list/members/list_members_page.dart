import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class ListMembersPage extends ConsumerWidget {
  const ListMembersPage({
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  static const name = 'list_members';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedUsersPage(
      provider: listMembersProvider(listId),
      title: '$listName members',
      errorMessage: 'error loading list members',
      noDataMessage: 'no members found',
    );
  }
}
