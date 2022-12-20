import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends ConsumerWidget {
  const WebviewPage({
    required this.initialUrl,
  });

  static const String name = 'webview';

  final String initialUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(webViewProvider(initialUrl));
    final notifier = ref.watch(webViewProvider(initialUrl).notifier);

    return HarpyScaffold(
      safeArea: true,
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: state.hasTitle
                ? Text(state.title!, overflow: TextOverflow.ellipsis)
                : null,
            fittedTitle: false,
            actions: [WebViewActions(notifier: notifier, state: state)],
          ),
          SliverFillRemaining(
            child: _WebView(
              state: state,
              notifier: notifier,
              initialUrl: initialUrl,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebView extends StatelessWidget {
  const _WebView({
    required this.state,
    required this.notifier,
    required this.initialUrl,
  });

  final WebViewState state;
  final WebViewStateNotifier notifier;
  final String initialUrl;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (state.canGoBack) {
          notifier.goBack().ignore();
          return false;
        }

        return true;
      },
      child: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: notifier.onWebViewCreated,
        onPageStarted: notifier.onPageStarted,
        onPageFinished: notifier.onPageFinished,
        gestureRecognizers: const {Factory(EagerGestureRecognizer.new)},
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
