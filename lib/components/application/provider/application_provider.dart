import 'package:flutter/cupertino.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:visibility_detector/visibility_detector.dart';

final applicationStateProvider = StateProvider(
  (ref) => ApplicationState.uninitialized,
  name: 'ApplicationStateProvider',
);

final applicationProvider = Provider(
  (ref) => Application(ref: ref),
  name: 'ApplicationProvider',
);

class Application with LoggerMixin {
  const Application({
    required Ref ref,
  }) : _ref = ref;

  final Ref _ref;

  Future<void> initialize({String? redirect}) async {
    initializeLogger();

    // for smooth gradients
    Paint.enableDithering = true;

    // set the visibility detector controller update interval to fire more
    // frequently
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 50,
    );

    await Future.wait([
      FlutterDisplayMode.setHighRefreshRate().handleError(logErrorHandler),
      _ref.read(deviceInfoProvider.notifier).initialize(),
      _ref.read(connectivityProvider.notifier).initialize(),
      _ref.read(authenticationProvider).restoreSession(),
    ]);

    _ref.read(applicationStateProvider.notifier).state =
        ApplicationState.initialized;

    if (_ref.read(authenticationStateProvider).isAuthenticated) {
      log.fine('authenticated after initialization');

      if (redirect != null) {
        // TODO: should push as we don't want to build the stack when deep
        //  linking into the app
        _ref.read(routerProvider).go(redirect);
      } else {
        _ref.read(routerProvider).goNamed(
          HomePage.name,
          queryParams: {'transition': 'fade'},
        );
      }
    } else {
      log.fine('not authenticated after initialization');

      _ref.read(routerProvider).goNamed(
        LoginPage.name,
        queryParams: {'transition': 'fade'},
      );
    }
  }
}

enum ApplicationState {
  uninitialized,
  initialized,
}
