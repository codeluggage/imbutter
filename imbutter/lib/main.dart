import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  var app = shelf_router.Router();

  app.get('/hello', (Request request) {
    return Response.ok('hello-world');
  });

  app.get('/user/<user>', (Request request, String user) {
    return Response.ok('hello $user');
  });

  var _port = 8080;
  var server = await io.serve(app, 'localhost', _port);
  debugPrint(server.toString());

  final res = await http.get(Uri.http('localhost:$_port', '/'));
  debugPrint(res.toString());
  debugPrint(res.body);

  final hello = await http.get(Uri.http('localhost:$_port', '/hello'));
  debugPrint(hello.toString());
  debugPrint(hello.body);

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

  // void loadLocalHtml() async {
  //   final html = await rootBundle.loadString('assets/index.html');

  //   final url = Uri.dataFromString(
  //     html,
  //     mimeType: 'text/html',
  //     encoding: Encoding.getByName('utf-8'),
  //   ).toString();

  //   controller.loadUrl(url);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'assets/index.html',
          onWebViewCreated: (controller) {
            this.controller = controller;

            // loadLocalHtml();
          },
          javascriptChannels: {
            JavascriptChannel(
              name: 'JavascriptChannel',
              onMessageReceived: (message) async {
                print('Javascript: "${message.message}"');
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      message.message,
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );

                controller.webViewController.evaluateJavascript('ok()');
              },
            ),
          },
        ),
      );
}
