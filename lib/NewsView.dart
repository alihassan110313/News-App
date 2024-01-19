import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'as WebViewFlutter;
import 'package:webviewx/webviewx.dart';
class NewsView extends StatefulWidget {

  String url;
  NewsView(this.url);
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late  String finalUrl;
  final Completer<WebViewFlutter.WebViewController> controller = Completer<WebViewFlutter.WebViewController>();
  @override
  void initState() {
    if(widget.url.toString().contains("http://"))
    {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl = widget.url;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("ZEIGE NEWS"),
        centerTitle: true,
      ),
      body: Container(
        child: WebViewFlutter.WebView(
          initialUrl: finalUrl,
          javascriptMode: WebViewFlutter.JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewFlutter.WebViewController webViewController){
            setState(() {
              controller.complete(webViewController);
            });
          },
        ),
      ),
    );
  }
}
