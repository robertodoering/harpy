import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'web_view_provider.freezed.dart';

final webViewProvider = StateNotifierProvider.autoDispose
    .family<WebViewStateNotifier, WebViewState, String>(
  (ref, initialUrl) {
    return WebViewStateNotifier(initialUrl: initialUrl);
  },
);

class WebViewStateNotifier extends StateNotifier<WebViewState> {
  WebViewStateNotifier({
    required String initialUrl,
  }) : super(WebViewState(currentUrl: initialUrl));

  late final WebViewController? _controller;

  Future<void> onWebViewCreated(WebViewController controller) async {
    _controller = controller;
  }

  Future<void> onPageStarted(String url) async {
    state = state.copyWith(
      currentUrl: url,
      loading: true,
      progress: 0,
    );

    state = state.copyWith(
      canGoBack: await _controller?.canGoBack() ?? false,
      canGoForward: await _controller?.canGoForward() ?? false,
    );
  }

  Future<void> onPageFinished(String url) async {
    state = state.copyWith(
      currentUrl: url,
      loading: false,
    );

    state = state.copyWith(
      title: await _controller?.getTitle(),
    );
  }

  void onProgress(int progress) {
    state = state.copyWith(progress: progress);
  }

  Future<void> reload() async {
    return _controller?.reload();
  }

  Future<void> goBack() async {
    return _controller?.goBack();
  }

  Future<void> goForward() async {
    return _controller?.goForward();
  }
}

@freezed
class WebViewState with _$WebViewState {
  factory WebViewState({
    required String currentUrl,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    String? title,
    @Default(false) bool loading,
    @Default(0) int progress,
  }) = _WebViewState;

  WebViewState._();

  late final hasTitle = title != null && title!.isNotEmpty;
}
