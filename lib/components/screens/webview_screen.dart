import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Builds a [WebView] inside a [HarpyScaffold] and shows the html content of
/// [url].
class WebviewScreen extends StatefulWidget {
  const WebviewScreen({
    @required this.url,
    this.displayUrl,
  });

  final String url;
  final String displayUrl;

  @override
  WebviewScreenState createState() => WebviewScreenState();
}

class WebviewScreenState extends State<WebviewScreen> {
  WebViewController _controller;

  /// The actions that will appear in the menu of a [PopupMenuItem].
  Map<String, VoidCallback> _actions;

  Future<void> _goBack() async => _controller?.goBack();
  Future<void> _goForward() async => _controller?.goForward();
  Future<void> _reload() async => _controller?.reload();
  Future<void> _openExternally() async =>
      launchUrl(await _controller.currentUrl());

  /// Builds the actions for the appbar in the [HarpyScaffold].
  List<Widget> _buildActions() {
    return <Widget>[
      PopupMenuButton<String>(
        onSelected: (title) => _actions[title](),
        itemBuilder: (context) {
          return _actions.keys.map((title) {
            if (title == "Navigation") {
              // build a row with icons for the back, forward and reload actions
              return PopupMenuItem<String>(
                enabled: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _goBack,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _goForward,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _reload,
                    ),
                  ],
                ),
              );
            }

            return PopupMenuItem<String>(
              value: title,
              child: Text(title),
            );
          }).toList();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _actions ??= {
      "Navigation": () {},
      "Open externally": _openExternally,
    };

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
              headline6: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(letterSpacing: 1),
            ),
      ),
      child: HarpyScaffold(
        title: widget.displayUrl ?? widget.url,
        actions: _buildActions(),
        body: WebView(
          initialUrl: widget.url,
          onWebViewCreated: (controller) => _controller = controller,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
