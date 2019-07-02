import 'package:connectivity/connectivity.dart';
import 'package:logging/logging.dart';

class ConnectivityService {
  ConnectivityService() {
    _log.fine("listening to connectivity status changes");
    Connectivity().onConnectivityChanged.listen((result) {
      _log.fine("connectivity state changed to $result");
      _lastResult = result;
    });
  }

  static final Logger _log = Logger("ConnectivityService");

  ConnectivityResult _lastResult;

  bool get mobile => _lastResult == ConnectivityResult.mobile;

  bool get wifi => _lastResult == ConnectivityResult.wifi;

  Future<void> init() async {
    _lastResult = await Connectivity().checkConnectivity();
  }
}
