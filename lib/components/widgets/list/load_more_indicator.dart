import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds a sliver for the end of a [CustomScrollView] indicating that more
/// data is being requested.
class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        padding: config.edgeInsets,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
