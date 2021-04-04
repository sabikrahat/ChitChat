import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ContactMePage extends StatefulWidget {
  @override
  _ContactMePageState createState() => _ContactMePageState();
}

class _ContactMePageState extends State<ContactMePage> {
  InAppWebViewController _webViewController;
  double progress = 0;
  String urls = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Me"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (_webViewController != null) {
                _webViewController.reload();
              }
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    valueColor:
                        AlwaysStoppedAnimation(Colors.indigoAccent[600]),
                  )
                : Center(),
            Expanded(
              child: InAppWebView(
                initialUrl: 'https://sabikrahat72428.blogspot.com/',
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                ),
                onProgressChanged: (_, load) {
                  setState(() {
                    progress = load / 100;
                  });
                },
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (_, url) {
                  setState(() {
                    urls = url;
                  });
                  print('***** $urls *****');
                },
                onLoadStop: (_, url) {
                  setState(() {
                    urls = url;
                  });
                  print('*****0000 $urls 0000*****');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
