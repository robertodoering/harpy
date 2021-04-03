import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddListRow extends StatelessWidget {
  const AddListRow();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(CupertinoIcons.add),
        title: const Text('add list'),
        subtitle: const Text('(coming soon!)'),
        onTap: () {},
      ),
    );
  }
}
