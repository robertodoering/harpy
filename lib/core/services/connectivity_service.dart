import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:harpy/core/core.dart';

/// Uses the [Connectivity] plugin to listen to connectivity changes.
class ConnectivityService with HarpyLogger {
  ConnectivityService() {
    log.fine('listening to connectivity status changes');

    Connectivity().onConnectivityChanged.listen((result) {
      log.fine('connectivity state changed to $result');
      _lastResult = result;
    });
  }

  /// The last [ConnectivityResult] that is updated automatically whenever the
  /// state changes.
  ConnectivityResult _lastResult = ConnectivityResult.mobile;

  /// Whether the device is currently connected to a cellular network.
  bool get mobile => _lastResult == ConnectivityResult.mobile;

  /// Whether the device is currently connected to a wifi network.
  ///
  /// This doesn't necessarily mean it also has an internet connection.
  bool get wifi => _lastResult == ConnectivityResult.wifi;

  Future<void> initialize() async {
    try {
      _lastResult = await Connectivity().checkConnectivity();
    } catch (e, st) {
      log.warning('unable to initialize connectivity', e, st);
    }
  }
}
