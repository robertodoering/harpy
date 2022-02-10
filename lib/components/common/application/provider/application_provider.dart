import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

final applicationProvider = Provider(
  Application.new,
  name: 'ApplicationProvider',
);

class Application with LoggerMixin {
  const Application(this._ref);

  final Ref _ref;

  Future<void> initialize() async {
    if (!kReleaseMode && !isTest) {
      initializeLogger();
    }

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
      _ref.read(deviceInfoServiceProvider).initialize(),
      _ref.read(connectivityServiceProvider).initialize(),
      _ref.read(authenticationProvider).restoreSession(),
    ]);

    if (_ref.read(authenticationStateProvider).isAuthenticated) {
      log.fine('authenticated after initialization');

      _ref.read(routerProvider).goNamed(
        HomePage.name,
        queryParams: {'origin': 'splash'},
      );
    } else {
      log.fine('not authenticated after initialization');

      _ref.read(routerProvider).goNamed(
        LoginPage.name,
        queryParams: {'origin': 'splash'},
      );
    }
  }
}
