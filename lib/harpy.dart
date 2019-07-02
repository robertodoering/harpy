import 'package:flutter/material.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/core/misc/harpy_catcher.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/global_models_wrapper.dart';
import 'package:harpy/models/settings/setting_models_wrapper.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

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
  static Flavor flavor;

  static bool get isFree => flavor == Flavor.free;
  static bool get isPro => flavor == Flavor.pro;

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

enum Flavor {
  free,
  pro,
}
