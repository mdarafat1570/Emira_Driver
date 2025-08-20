import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../components/app-bar/custom_appbar.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final bool appBar;
  final bool showBackButton;
  final Color appBarColor;

  const WebViewPage({Key? key, required this.title, required this.url, this.appBar = true, this.showBackButton = true, this.appBarColor = Colors.blue}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webViewController;
  bool isLoading = true;

  final InAppWebViewSettings options = InAppWebViewSettings(
    javaScriptEnabled: true,
    allowFileAccess: true,
    allowsInlineMediaPlayback: true,
    useHybridComposition: true,
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        isShowBackBtn: widget.showBackButton,
        isTitleCenter: true,
        bgColor: widget.appBarColor,
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url!;
              if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
                  .contains(uri.scheme)) {
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
