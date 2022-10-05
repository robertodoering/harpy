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

  Future<void> onControllerCreated(WebViewController controller) async {
    _controller = controller;

    state = await _stateByCurrentController(url: state.currentUrl);
  }

  Future<void> onPageLoaded(String url) async {
    state = await _stateByCurrentController(url: url);
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

  Future<WebViewState> _stateByCurrentController({
    required String url,
  }) async {
    if (_controller == null) {
      /// if controller is not set up yet don't emit a new state
      return state;
    }

    final title = await _controller!.getTitle();
    final canGoBack = await _controller!.canGoBack();
    final canGoForward = await _controller!.canGoForward();

    return WebViewState(
      currentUrl: url,
      title: title,
      canGoBack: canGoBack,
      canGoForward: canGoForward,
    );
  }
}

@freezed
class WebViewState with _$WebViewState {
  factory WebViewState({
    required String currentUrl,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    String? title,
  }) = _WebViewState;

  WebViewState._();

  late final hasTitle = title != null && title!.isNotEmpty;
}
