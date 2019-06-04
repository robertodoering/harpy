import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// Wraps the settings [Provider]s and holds the instances in its state.
///
/// Similar to [GlobalModelsWrapper] for settings.
class SettingModelsWrapper extends StatefulWidget {
  const SettingModelsWrapper({
    @required this.child,
  });

  final Widget child;

  @override
  _SettingModelsWrapperState createState() => _SettingModelsWrapperState();
}

class _SettingModelsWrapperState extends State<SettingModelsWrapper> {
  MediaSettingsModel mediaSettingsModel;
  ThemeSettingsModel themeSettingsModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    mediaSettingsModel ??= MediaSettingsModel(
      harpyPrefs: serviceProvider.data.harpyPrefs,
      connectivityService: serviceProvider.data.connectivityService,
    );

    themeSettingsModel ??= ThemeSettingsModel(
      harpyPrefs: serviceProvider.data.harpyPrefs,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MediaSettingsModel>(
          builder: (_) => mediaSettingsModel,
        ),
        ChangeNotifierProvider<ThemeSettingsModel>(
          builder: (_) => themeSettingsModel,
        ),
      ],
      child: widget.child,
    );
  }
}
