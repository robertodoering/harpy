import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a sliver for the end of a [CustomListView] indicating that loading
/// more data is currently not possible.
class LoadingMoreLocked extends StatelessWidget {
  const LoadingMoreLocked({
    this.type = 'data',
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return SliverToBoxAdapter(
      child: Container(
        height: mediaQuery.padding.bottom * 2,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Please wait a moment until more $type can be requested',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
