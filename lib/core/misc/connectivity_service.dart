import 'package:connectivity/connectivity.dart';
import 'package:logging/logging.dart';

/// Uses the [Connectivity] plugin to listen to connectivity changes.
///
/// Should be initialized to set the initial connectivity state.
class ConnectivityService {
  ConnectivityService() {
    _log.fine("listening to connectivity status changes");
    Connectivity().onConnectivityChanged.listen((result) {
      _log.fine("connectivity state changed to $result");
      _lastResult = result;
    });
  }

  static final Logger _log = Logger("ConnectivityService");

  /// The last [ConnectivityResult] that is updated automatically whenever the
  /// state changes.
  ConnectivityResult _lastResult;

  /// `true` if the device is currently connected to a cellular network.
  bool get mobile => _lastResult == ConnectivityResult.mobile;

  /// `true` if the device is currently connected to a wifi.
  ///
  /// This doesn't necessarily mean it also has an internet connection.
  bool get wifi => _lastResult == ConnectivityResult.wifi;

  Future<void> init() async {
    _lastResult = await Connectivity().checkConnectivity();
  }
}
