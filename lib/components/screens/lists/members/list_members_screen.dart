import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class ListMembersScreen extends StatelessWidget {
  const ListMembersScreen({
    required this.listId,
    this.name,
  });

  final String listId;
  final String? name;

  static const route = 'list_members_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListMembersBloc(listId: listId),
      child: HarpyScaffold(
        body: TwitterListMembers(
          name: name,
        ),
      ),
    );
  }
}
