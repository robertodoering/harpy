import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

/// Builds a sliver for the end of a [CustomListView] indicating that more data
/// is being requested.
class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        padding: DefaultEdgeInsets.all(),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
