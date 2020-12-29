import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text('WebView'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WebViewPage();
              },));
            },
          )
        ],
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebViewPage'),
      ),
      body: WebView(
        initialUrl: 'https://github.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}