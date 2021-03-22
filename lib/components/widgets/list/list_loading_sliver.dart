import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds a sliver with a [CircularProgressIndicator] indicating that the list
/// content is currently loading.
class ListLoadingSliver extends StatelessWidget {
  const ListLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: ListCardAnimation(
        key: Key('loading'),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
