import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Articles extends StatefulWidget {
  final String articleUrl;
  Articles({this.articleUrl});

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  bool _isLoading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=>Navigator.pop(context,false),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('News'),
            Text(
              'tant',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),
          )
        ],
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.articleUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebViewCreated: ((WebViewController webViewController) {
              _completer.complete(webViewController);
            }),
          ),
          _isLoading
              ? Center(
                  child: Container(
                  child: CircularProgressIndicator(),
                ))
              : SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                  ),
                )
        ],
      ),
    );
  }
}
