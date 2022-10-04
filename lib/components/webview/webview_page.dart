import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class WebviewPage extends ConsumerWidget {
  const WebviewPage({
    required this.initialUrl,
  });

  static const String name = 'webview';
  static const String path = '/webview';

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
            title: state.hasTitle ? Text(state.title!) : null,
            actions: [
              WebViewActions(
                notifier: notifier,
                state: state,
              ),
            ],
          ),
          SliverFillRemaining(
            child: HarpyWebView(
              initialUrl: initialUrl,
            ),
          ),
        ],
      ),
    );
  }
}
