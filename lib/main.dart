import 'package:flutter/material.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/core/misc/harpy_catcher.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/global_models_wrapper.dart';
import 'package:harpy/models/settings/setting_models_wrapper.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ThemeSettingsModel>(
      builder: (context, themeModel, _) {
        return MaterialApp(
          title: "Harpy",
          theme: themeModel.harpyTheme.theme,
          navigatorKey: HarpyNavigator.key,
          home: EntryScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
