import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsModel extends Model {
  SettingsModel({
    @required this.harpyPrefs,
  }) : assert(harpyPrefs != null);

  final HarpyPrefs harpyPrefs;

  static SettingsModel of(BuildContext context) {
    return ScopedModel.of<SettingsModel>(context);
  }

  static final Logger _log = Logger("SettingsModel");
}
