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

  final Completer<WebViewController> _controllerCreation = Completer();

  Future<void> onControllerCreated(WebViewController controller) async {
    _controllerCreation.complete(controller);

    state = await _stateByCurrentController(url: state.currentUrl);
  }

  Future<void> onPageLoaded(String url) async {
    if (_controllerCreation.isCompleted) {
      state = await _stateByCurrentController(url: url);
    }
  }

  Future<void> reload() async {
    final controller = await _controllerCreation.future;
    return controller.reload();
  }

  Future<void> goBack() async {
    final controller = await _controllerCreation.future;
    return controller.goBack();
  }

  Future<void> goForward() async {
    final controller = await _controllerCreation.future;
    return controller.goForward();
  }

  Future<WebViewState> _stateByCurrentController({
    required String url,
  }) async {
    final controller = await _controllerCreation.future;

    final title = await controller.getTitle();
    final canGoBack = await controller.canGoBack();
    final canGoForward = await controller.canGoForward();

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
