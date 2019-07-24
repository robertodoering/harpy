import 'package:flutter/material.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:provider/provider.dart';

import 'theme_settings_model.dart';

/// Creates a [MultiProvider] with each settings model.
///
/// These models are above the root [MaterialApp] and are only created once.
class SettingsModelsProvider extends StatelessWidget {
  const SettingsModelsProvider({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MediaSettingsModel>(
          builder: (_) => MediaSettingsModel(),
        ),
        ChangeNotifierProvider<ThemeSettingsModel>(
          builder: (_) => ThemeSettingsModel(),
        ),
      ],
      child: child,
    );
  }
}
