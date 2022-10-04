import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HarpyWebView extends ConsumerWidget {
  const HarpyWebView({
    required this.initialUrl,
  });

  final String initialUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(webViewProvider(initialUrl).notifier);

    return WebView(
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: notifier.onControllerCreated,
      onPageFinished: notifier.onPageLoaded,
      gestureRecognizers: const {Factory(EagerGestureRecognizer.new)},
    );
  }
}
