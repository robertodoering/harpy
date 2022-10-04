import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:share_plus/share_plus.dart';

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

    return HarpyScaffold(
      safeArea: true,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          HarpySliverAppBar(
            title: state.title != null ? Text(state.title!) : null,
            actions: [
              HarpyPopupMenuButton(
                onSelected: (_) async {
                  await Share.share(state.currentUrl);
                },
                itemBuilder: (_) => [
                  const HarpyPopupMenuItem(
                    value: true,
                    title: Text('share url'),
                  )
                ],
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
