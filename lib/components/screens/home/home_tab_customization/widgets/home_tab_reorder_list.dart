import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HomeTabReorderList extends StatelessWidget {
  const HomeTabReorderList();

  @override
  Widget build(BuildContext context) {
    final HomeTabModel model = context.watch<HomeTabModel>();

    return ReorderableList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.value.entries.length,
      onReorder: model.reorder,
      itemBuilder: (_, int index) => HomeTabReorderCard(
        index: index,
        model: model,
      ),
    );
  }
}
