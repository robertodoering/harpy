import 'package:flutter/material.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/global_models.dart';
import 'package:harpy/models/theme_model.dart';
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
      builder: (context, _, themeModel) {
        return MaterialApp(
          title: "Harpy",
          theme: themeModel.harpyTheme.theme,
          home: EntryScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
