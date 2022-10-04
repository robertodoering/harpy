import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'web_view_provider.freezed.dart';

final webViewProvider = StateNotifierProvider.autoDispose
    .family<WebviewStateNotifier, WebViewState, String>(
  (ref, initialUrl) {
    return WebviewStateNotifier(initialUrl: initialUrl);
  },
);

class WebviewStateNotifier extends StateNotifier<WebViewState> {
  WebviewStateNotifier({
    required String initialUrl,
  }) : super(WebViewState(currentUrl: initialUrl));

  final Completer<WebViewController> _controllerCreation = Completer();

  Future<void> onControllerCreated(WebViewController controller) async {
    _controllerCreation.complete(controller);

    final currentUrl = await controller.currentUrl();
    final title = await controller.getTitle();

    state = WebViewState(
      currentUrl: currentUrl!,
      title: title,
    );
  }

  Future<void> onPageLoaded(String url) async {
    if (_controllerCreation.isCompleted) {
      final controller = await _controllerCreation.future;
      final title = await controller.getTitle();

      state = WebViewState(
        currentUrl: url,
        title: title,
      );
    }
  }
}

@freezed
class WebViewState with _$WebViewState {
  const factory WebViewState({
    required String currentUrl,
    String? title,
  }) = _WebViewState;
}
