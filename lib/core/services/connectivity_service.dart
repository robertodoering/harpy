import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityResult>(
  (ref) => ConnectivityNotifier(),
  name: 'ConnectivityProvider',
);

class ConnectivityNotifier extends StateNotifier<ConnectivityResult> {
  ConnectivityNotifier() : super(ConnectivityResult.mobile) {
    Connectivity().onConnectivityChanged.listen(
          (connectivity) => state = connectivity,
          onError: logErrorHandler,
        );
  }

  Future<void> initialize() async {
    await Connectivity()
        .checkConnectivity()
        .then((value) => state = value)
        .handleError(logErrorHandler);
  }
}
