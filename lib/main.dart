import 'package:flutter/material.dart';
import 'package:harpy/models/global_models.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/theme.dart';
import 'package:harpy/ui/screens/entry_screen.dart';

void main() {
  runApp(ServiceProvider(
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
