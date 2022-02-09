import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/rby/rby.dart';

final connectivityProvider = StateProvider(
  (ref) => ConnectivityResult.mobile,
  name: 'ConnectivityProvider',
);

final connectivityServiceProvider = Provider(
  ConnectivityService.new,
  name: 'ConnectivityServiceProvider',
);

/// Uses the [Connectivity] plugin to listen to connectivity changes.
class ConnectivityService with LoggerMixin {
  ConnectivityService(this._ref) {
    Connectivity().onConnectivityChanged.listen((connectivity) {
      _ref.read(connectivityProvider.notifier).state = connectivity;
    });
  }

  final Ref _ref;

  Future<void> initialize() async {
    final connectivity = await Connectivity().checkConnectivity().handleError(
          logErrorHandler,
        );

    if (connectivity != null) {
      _ref.read(connectivityProvider.notifier).state = connectivity;
    }
  }
}
