import 'package:flutter/material.dart';
import 'package:harpy/models/global_models.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:harpy/widgets/screens/entry_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(ServiceContainer(
    child: GlobalScopedModels(
      child: Harpy(),
    ),
  ));
}

class Harpy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ThemeModel>(
      builder: (context, _, model) {
        return MaterialApp(
          title: "Harpy",
          theme: model.harpyTheme.theme,
          home: EntryScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
