import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';
import 'package:share_plus/share_plus.dart';

enum WebViewAction {
  share,
  reload,
  forward,
  back,
}

class WebViewActions extends StatelessWidget {
  const WebViewActions({
    required this.notifier,
    required this.state,
  });

  final WebViewStateNotifier notifier;
  final WebViewState state;

  @override
  Widget build(BuildContext context) {
    return RbyPopupMenuButton<WebViewAction>(
      onSelected: (action) async {
        switch (action) {
          case WebViewAction.share:
            Share.share(state.currentUrl).ignore();
            break;
          case WebViewAction.reload:
            notifier.reload().ignore();
            break;
          case WebViewAction.forward:
            notifier.goForward().ignore();
            break;
          case WebViewAction.back:
            notifier.goBack().ignore();
            break;
        }
      },
      itemBuilder: (_) => [
        RbyPopupMenuRow(
          children: [
            RbyPopupMenuIcon(
              icon: const Icon(Icons.arrow_back_rounded),
              value: WebViewAction.back,
              enabled: state.canGoBack,
            ),
            RbyPopupMenuIcon(
              icon: const Icon(Icons.arrow_forward_rounded),
              value: WebViewAction.forward,
              enabled: state.canGoForward,
            ),
            const RbyPopupMenuIcon(
              value: WebViewAction.reload,
              icon: Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const RbyPopupMenuListTile(
          leading: Icon(Icons.share_rounded),
          title: Text('share url'),
          value: WebViewAction.share,
        ),
      ],
    );
  }
}
