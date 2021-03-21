import 'package:flutter/services.dart';

/// Used with the [MediaOverlay] for [TweetMedia] controls.
class TweetMediaModel {
  bool _showingOverlays = true;
  bool get showingOverlays => _showingOverlays;

  void resetOverlays() {
    if (!_showingOverlays) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      _showingOverlays = true;
    }
  }

  void toggleOverlays() {
    if (_showingOverlays) {
      SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
      _showingOverlays = false;
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      _showingOverlays = true;
    }
  }
}
