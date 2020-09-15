import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a sliver for the end of a [CustomListView] indicating that more data
/// is being requested.
class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Loading...',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
