import 'package:flutter/material.dart';

// todo
class ProFeatureDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Pro only feature",
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }
}
