import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/core/misc/harpy_catcher.dart';
import 'package:harpy/models/global_models_wrapper.dart';
import 'package:harpy/models/settings/setting_models_wrapper.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  HarpyCatcher(
    ServiceContainer(
      child: SettingModelsWrapper(
        child: GlobalModelsWrapper(
          child: Harpy(),
        ),
      ),
    ),
  );
}

class Harpy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ThemeSettingsModel>(
      builder: (context, _, themeModel) {
        return MaterialApp(
          title: "Harpy",
          theme: themeModel.harpyTheme.theme,
          navigatorKey: Catcher.navigatorKey,
          builder: (context, child) => GlobalScaffold(child: child),
          home: EntryScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
