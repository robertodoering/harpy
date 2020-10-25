import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Used with the [MediaOverlay] for [TweetMedia] controls.
class TweetMediaModel {
  static TweetMediaModel of(BuildContext context) =>
      Provider.of<TweetMediaModel>(context);

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
