import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Wraps the settings [ScopedModel]s and holds the instances in its state.
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

    return ScopedModel<MediaSettingsModel>(
      model: mediaSettingsModel,
      child: ScopedModel<ThemeSettingsModel>(
        model: themeSettingsModel,
        child: widget.child,
      ),
    );
  }
}
