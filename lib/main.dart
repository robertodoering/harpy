import 'package:flutter/material.dart';
import 'package:harpy/models/global_models.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/theme.dart';
import 'package:harpy/widgets/screens/entry_screen.dart';

void main() {
  runApp(ServiceContainer(
    child: GlobalScopedModels(
      child: MaterialApp(
        title: "Harpy",
        theme: HarpyTheme.light().theme,
        home: EntryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  ));
}
