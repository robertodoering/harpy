import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/settings/settings_tile.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:provider/provider.dart';

class MediaSettingsScreen extends StatelessWidget {
  List<Widget> _getSettings(MediaSettingsModel model) {
    return [
      DropdownSettingsTile(
        leading: Icons.signal_wifi_4_bar,
        title: "Default quality on WiFi",
        value: model.wifiMediaQuality,
        items: ["High", "Medium", "Small"],
        onChanged: model.changeWifiMediaQuality,
      ),
      DropdownSettingsTile(
        leading: Icons.signal_wifi_off,
        title: "Default quality on mobile data",
        value: model.nonWifiMediaQuality,
        items: ["High", "Medium", "Small"],
        onChanged: model.changeNonWifiMediaQuality,
      ),
      DropdownSettingsTile(
        leading: Icons.visibility,
        title: "Show media initially",
        value: model.defaultHideMedia,
        items: ["Always show", "Only on WiFi", "Never show"],
        onChanged: model.changeDefaultHideMedia,
      ),
      DropdownSettingsTile(
        leading: Icons.play_circle_outline,
        title: "Autoplay gifs",
        value: model.autoplayMedia,
        items: ["Always autoplay", "Only on WiFi", "Never autoplay"],
        onChanged: model.changeAutoplayMedia,
        enabled: model.enableAutoplayMedia,
      ),
    ];
  }

  /// Builds the [HarpyScaffold] actions for the "reset to default" button as a
  /// [PopupMenuItem].
  List<Widget> _buildActions(MediaSettingsModel model) {
    return <Widget>[
      PopupMenuButton<int>(
        onSelected: (value) => model.defaultSettings(),
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Reset to default"),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaSettingsModel>(
      builder: (context, model, _) {
        return HarpyScaffold(
          title: "Media settings",
          actions: _buildActions(model),
          body: ListView(
            padding: EdgeInsets.zero,
            children: _getSettings(model),
          ),
        );
      },
    );
  }
}
