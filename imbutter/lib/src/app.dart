import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'WebView';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

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
          title: const Text(MyApp.title),
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
                debugPrint('Javascript: "${message.message}"');

                // await showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     content: Text(
                //       message.message,
                //       style: const TextStyle(fontSize: 20),
                //     ),
                //     actions: [
                //       TextButton(
                //         child: const Text('OK'),
                //         onPressed: () => Navigator.pop(context),
                //       ),
                //     ],
                //   ),
                // );

                controller.webViewController
                    .runJavascriptReturningResult('ok()')
                    .then((value) => debugPrint(value));
              },
            ),
          },
        ),
      );
}
