import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/news_response.dart';

class NewsWebView extends StatefulWidget {
  const NewsWebView({super.key});

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late Article article;
  WebViewController? controller;
  int progress = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller != null) return;
    article = ModalRoute.of(context)!.settings.arguments as Article;
    var publisher = article.link!.host.replaceFirst('www.', '');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            var url = Uri.tryParse(request.url);
            if (url != null &&
                (url.scheme == 'https' || url.scheme == 'http') &&
                url.host.replaceFirst('www.', '') == publisher) {
              return NavigationDecision.navigate;
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are not allowed to visit this site.'),
                ),
              );
            }
            return NavigationDecision.prevent;
          },
          onPageStarted: (url) {
            if (mounted) setState(() => progress = 0);
          },
          onProgress: (value) {
            if (mounted) setState(() => progress = value);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => progress = 100);
          },
        ),
      )
      ..loadRequest(article.link!);
  }

  @override
  Widget build(BuildContext context) {
    var webView = controller!;
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Previous page',
            onPressed: webView.goBack,
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            tooltip: 'Reload',
            onPressed: webView.reload,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Next page',
            onPressed: webView.goForward,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webView),
          if (progress < 100)
            LinearProgressIndicator(value: progress / 100, color: Colors.red),
        ],
      ),
    );
  }
}
