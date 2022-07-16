import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

final applicationStateProvider = StateProvider(
  (ref) => ApplicationState.uninitialized,
  name: 'ApplicationStateProvider',
);

final applicationProvider = Provider(
  (ref) => Application(read: ref.read),
  name: 'ApplicationProvider',
);

class Application with LoggerMixin {
  const Application({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  Future<void> initialize({String? redirect}) async {
    initializeLogger();

    // for smooth gradients
    Paint.enableDithering = true;

    // set the visibility detector controller update interval to fire more
    // frequently
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 50,
    );

    if (Platform.isAndroid) {
      // set the webview implementation (used for authentication)
      WebView.platform = SurfaceAndroidWebView();
    }

    await Future.wait([
      FlutterDisplayMode.setHighRefreshRate().handleError(logErrorHandler),
      _read(deviceInfoProvider.notifier).initialize(),
      _read(connectivityProvider.notifier).initialize(),
      _read(authenticationProvider).restoreSession(),
    ]);

    _read(applicationStateProvider.notifier).state =
        ApplicationState.initialized;

    if (_read(authenticationStateProvider).isAuthenticated) {
      log.fine('authenticated after initialization');

      if (redirect != null) {
        _read(routerProvider).go(redirect);
      } else {
        _read(routerProvider).goNamed(
          HomePage.name,
          queryParams: {'transition': 'fade'},
        );
      }
    } else {
      log.fine('not authenticated after initialization');

      _read(routerProvider).goNamed(
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
