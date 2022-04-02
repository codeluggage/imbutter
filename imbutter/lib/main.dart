import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'WebView';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebViewPlusController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (error) {
            debugPrint(error.toString());
          },
          initialUrl: 'assets/index.html',
          navigationDelegate: (NavigationRequest request) {
            debugPrint(request.toString());
            return NavigationDecision.navigate;
          },
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
        ),
      );
}
