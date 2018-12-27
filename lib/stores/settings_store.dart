import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/theme.dart';

class SettingsStore extends Store {
  static final Action<HarpyTheme> setTheme = Action();

  SettingsStore() {
    setTheme.listen((HarpyTheme harpyTheme) {
      HarpyTheme.instance = harpyTheme;
    });
  }
}
