import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// The initial content for the [FindLocationDialog] to allow the user how
/// they want to find locations.
class SelectFindMethodContent extends StatelessWidget {
  const SelectFindMethodContent({
    required this.onSelectNearLocation,
    required this.onSelectCustomLocation,
  });

  final VoidCallback onSelectNearLocation;
  final VoidCallback onSelectCustomLocation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(CupertinoIcons.location),
            title: const Text('locations near me'),
            onTap: onSelectNearLocation,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(CupertinoIcons.map_pin_ellipse),
            title: const Text('custom location'),
            onTap: onSelectCustomLocation,
          ),
        ],
      ),
    );
  }
}
