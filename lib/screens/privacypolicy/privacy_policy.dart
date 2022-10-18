import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController? _controla;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/priv_policy.html');
    _controla!.loadUrl(Uri.dataFromString(
      fileText,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     _controla!.canGoBack().then((value) {
          //       _controla!.goBack();
          //     });
          //   },
          //   icon: const Icon(Icons.arrow_back_ios),
          // ),
          // IconButton(
          //   onPressed: () {
          //     _controla!.canGoForward().then((value) {
          //       _controla!.goForward();
          //     });
          //   },
          //   icon: const Icon(Icons.arrow_forward_ios),
          // ),
        ],
      ),
      body: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controla = webViewController;
          _loadHtmlFromAssets();
        },
        // onWebViewCreated: (WebViewController webViewController) {
        //   _controller.complete(webViewController);
        // },
        gestureRecognizers: {}..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer())),
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        // navigationDelegate: (NavigationRequest request) {
        //   if (request.url.startsWith('https://www.youtube.com/')) {
        //     print('blocking navigation to $request}');
        //     return NavigationDecision.prevent;
        //   }
        //   print('allowing navigation to $request');
        //   return NavigationDecision.navigate;
        // },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
      ),
    );
  }
}
